//
//  SigningTests.swift
//  WalletTests
//
//  Created by Ronald Mannak on 10/18/21.
//

import XCTest
import MEWwalletKit
@testable import Wallet

// Based on ShapeShift unit tests: https://github.com/shapeshift/hdwallet/blob/master/packages/hdwallet-native/src/ethereum.test.ts
class SigningTests: XCTestCase {
    
    let mnemonic = "all all all all all all all all all all all all"
    let password = "password123"
    var manager: WalletManager!
    var wallet: Wallet<PrivateKeyEth1>!
    var seed: Data!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAddresses()
        self.seed = try BIP39(mnemonic: mnemonic.components(separatedBy: " ")).seed()
        self.wallet = try Wallet(seed: seed, network: .ethereum)
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
        let derivedPrivateKey = try wallet.derive(.ethereum, index: 0).privateKey
        XCTAssertEqual(derivedPrivateKey.address()!.address, "0x73d0385F4d8E00C5e6504C6030F47BF6212736A8")
    }
    
    
    func testSignEIP1559Transaction() throws {
        let derivedPrivateKey = try wallet.derive(.ethereum, index: 0).privateKey
        XCTAssertEqual(derivedPrivateKey.address()!.address, "0x73d0385F4d8E00C5e6504C6030F47BF6212736A8")
                
        let transaction = try EIP1559Transaction(
          nonce: "0xCAFEDEAD",
          maxPriorityFeePerGas: "0xCAFEDEAD",
          maxFeePerGas: "0xCAFEDEAD",
          gasLimit: "0xCAFEDEAD",
          from: derivedPrivateKey.address(),
          to: Address(raw: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEADCAFEDEAD"),
          value: "0xCAFEDEADCAFEDEADCAFEDEADCAFEDEAD",
          data: Data(),
          accessList: nil,
          chainID:nil // this should default to network in key
        )
        try transaction.sign(key: derivedPrivateKey)
        let serialized = transaction.serialize()!
//        XCTAssertEqual(serialized, Data(hex: "0x02f8900184cafedead84cafedead84cafedead84cafedead94cafedeadcafedeadcafedeadcafedeadcafedead90cafedeadcafedeadcafedeadcafedead90cafedeadcafedeadcafedeadcafedeadc080a07a2efa71aa876ede546fdfa83054050b6249a8076297451b2a711e6b0f460234a01880e95e79fed382b85077de63d83e787158c8a89839c786465139952cb04a74"))
//        XCTAssertEqual(serialized, Data(hex: "0xf88984deadbeef84deadbeef84deadbeef94deadbeefdeadbeefdeadbeefdeadbeefdeadbeef90deadbeefdeadbeefdeadbeefdeadbeef90deadbeefdeadbeefdeadbeefdeadbeef26a0ec482d7dfc3bfaf395b72dd1de692ab57c24134fb0bea39e986b16a4ad422d2fa0505506a0fb590d7ef63c24e9ae684eef608a6f48914d7cce762164d8c0a6fb29"))
        print(serialized.toHexString())
                
//        let signedHash = transaction.hash(chainID: transaction.chainID, forSignature: false)
//        XCTAssertEqual(signedHash, Data(hex: "0x73d0385F4d8E00C5e6504C6030F47BF6212736A8"))
    }
}


