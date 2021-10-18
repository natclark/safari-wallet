//
//  SigningTests.swift
//  WalletTests
//
//  Created by Ronald Mannak on 10/18/21.
//

import XCTest
import HDWalletKit
@testable import Wallet

// Based on ShapeShift unit tests: https://github.com/shapeshift/hdwallet/blob/master/packages/hdwallet-native/src/ethereum.test.ts
class SigningTests: XCTestCase {
    
    let mnemonic = "all all all all all all all all all all all all"
    let password = "password123"
    var manager: WalletManager!
    var seed: Data!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAddresses()
        seed = Mnemonic.createSeed(mnemonic: mnemonic)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testAddressGeneration() async throws {
        let privateKey = await PrivateKey(seed: seed, coin: .ethereum)
        let derivedPrivateKey = try await privateKey.privateKey(at: "m/44'/60'/0'/0/0")
        XCTAssertEqual(derivedPrivateKey.publicKey.address, "0x73d0385F4d8E00C5e6504C6030F47BF6212736A8")
    }
    
    /*
     const sig = await wallet.ethSignTx({
       addressNList: core.bip32ToAddressNList("m/44'/60'/0'/0/0"),
       nonce: "0xCAFEDEAD",
       gasLimit: "0xCAFEDEAD",
       maxFeePerGas: "0xCAFEDEAD",
       maxPriorityFeePerGas: "0xCAFEDEAD",
       to: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
       value: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
       data: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
       chainId: 1,
     });
     */
    func testSignTxManual() async throws {
        let privateKey = try await PrivateKey(seed: seed, coin: .ethereum).privateKey(at: "m/44'/60'/0'/0/0")
        let rawTx = EthereumRawTransaction(value: Wei("0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD", radix: 16)!, to: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEADCAFEDEAD", gasPrice: 0xDEADBEEF, gasLimit: 0xCAFEDEAD, nonce: 0xCAFEDEAD, data: Data.fromHex("0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD")!)
        
        let signature = try await EIP155Signer(chainId: 1).sign(rawTx, privateKey: privateKey)
        let (r, v, s)  = EIP155Signer(chainId: 1).calculateRSV(signature: signature)
        print(signature.toHexString())
        
        XCTAssertEqual(r, BInt("0x7f21bb5a857db55c888355b2e48325062268ad62686fba56a4e57118f5783dda", radix: 16))
        XCTAssertEqual(v, BInt(38))
        XCTAssertEqual(s, BInt("0x3e9893ed500842506a19288eb022b5f5b3cee6d1bbf6330f4304f60f8166f82a", radix: 16))
        
        XCTAssertEqual(signature, Data.fromHex("0x73d0385F4d8E00C5e6504C6030F47BF6212736A8"))
        XCTAssertEqual(signature.toHexString(), Data.fromHex("0x73d0385F4d8E00C5e6504C6030F47BF6212736A8"))
    }
    
    func testSignTxWallet() async throws {
        let ethAddress = EthereumAddress(address: manager.defaultAddress()!, walletName: manager.defaultHDWallet()!)
        let signature = try await ethAddress.sign(rawTx: rawTx)
        XCTAssertEqual(signature, Data.fromHex("0x73d0385F4d8E00C5e6504C6030F47BF6212736A8"))
    }

}
/*
 it("should sign a EIP-1559 transaction correctly", async () => {
   const sig = await wallet.ethSignTx({
     addressNList: core.bip32ToAddressNList("m/44'/60'/0'/0/0"),
     nonce: "0xCAFEDEAD",
     gasLimit: "0xCAFEDEAD",
     maxFeePerGas: "0xCAFEDEAD",
     maxPriorityFeePerGas: "0xCAFEDEAD",
     to: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
     value: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
     data: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
     chainId: 1,
   });
   console.log("SIG: ", sig)
   // This is the output from tiny-secp256k1.
   expect(sig).toMatchInlineSnapshot(`
     Object {
       "r": "0x7a2efa71aa876ede546fdfa83054050b6249a8076297451b2a711e6b0f460234",
       "s": "0x1880e95e79fed382b85077de63d83e787158c8a89839c786465139952cb04a74",
       "serialized": "0x02f8900184cafedead84cafedead84cafedead84cafedead94cafedeadcafedeadcafedeadcafedeadcafedead90cafedeadcafedeadcafedeadcafedead90cafedeadcafedeadcafedeadcafedeadc080a07a2efa71aa876ede546fdfa83054050b6249a8076297451b2a711e6b0f460234a01880e95e79fed382b85077de63d83e787158c8a89839c786465139952cb04a74",
       "v": 0,
     }
   `);
   // This is the output of the native library's own signing function.
   /*expect(sig).toMatchInlineSnapshot(`
     Object {
       "r": "0xec482d7dfc3bfaf395b72dd1de692ab57c24134fb0bea39e986b16a4ad422d2f",
       "s": "0x505506a0fb590d7ef63c24e9ae684eef608a6f48914d7cce762164d8c0a6fb29",
       "serialized": "0xf88984deadbeef84deadbeef84deadbeef94deadbeefdeadbeefdeadbeefdeadbeefdeadbeef90deadbeefdeadbeefdeadbeefdeadbeef90deadbeefdeadbeefdeadbeefdeadbeef26a0ec482d7dfc3bfaf395b72dd1de692ab57c24134fb0bea39e986b16a4ad422d2fa0505506a0fb590d7ef63c24e9ae684eef608a6f48914d7cce762164d8c0a6fb29",
       "v": 38,
     }
   `);*/
   expect(ethers.utils.parseTransaction(sig!.serialized).from).toEqual("0x73d0385F4d8E00C5e6504C6030F47BF6212736A8");
 });
*/
