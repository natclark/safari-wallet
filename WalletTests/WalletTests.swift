//
//  WalletTests.swift
//  WalletTests
//
//  Created by Ronald Mannak on 10/10/21.
//

import XCTest
import MEWwalletKit
@testable import Wallet

class WalletTests: XCTestCase {
    
    let mnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    let mnemonic2 = "all all all all all all all all all all all all"
    let password = "password123"
    var manager: WalletManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAddresses()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTFail()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveAddresses() async throws {
        let wallet: Wallet<PrivateKeyEth1> = try manager.restoreWallet(mnemonic: mnemonic)
        let filename = try await manager.saveWallet(mnemonic: mnemonic, password: password, storePasswordInKeychain: false)
        let savedAddresses = try await manager.saveAddresses(wallet: wallet, addressCount: 5, name: filename)
        let recoveredAddresses = try await manager.loadAddresses(name: filename)
        XCTAssertEqual(savedAddresses, recoveredAddresses)
        
        let generatedAddresses = try wallet.generateAddresses(count: 5).map{ $0.address }
        XCTAssertEqual(savedAddresses, generatedAddresses)

        let addressList = try manager.listAddressFiles()
        XCTAssertTrue(addressList.contains(try filename.appendPathExtension("eth").appendPathExtension("address")))
    }
    
    func testWalletEncryptionRoundtrip() async throws {
        let passwordData = password.data(using: .utf8)!
        let mnemonicData = mnemonic.data(using: .utf8)!
        guard let keystore = try await KeystoreV3(privateKey: mnemonicData, passwordData: passwordData) else {
            XCTFail()
            return
        }
        let decoded = try await keystore.getDecryptedKeystore(passwordData: passwordData)
        XCTAssertEqual(mnemonicData, decoded)
    }
    
    func testWalletFileRoundtrip() async throws {
        let wallet: Wallet<PrivateKeyEth1> = try manager.restoreWallet(mnemonic: mnemonic)
        let name = try await manager.saveWallet(mnemonic: mnemonic, password: password, storePasswordInKeychain: false)
        
        let restoredWallet = try await manager.loadWallet(name: name, password: password, network: .ethereum)
        XCTAssertEqual(wallet.privateKey.address()!.address, restoredWallet.privateKey.address()!.address)
    }

}
