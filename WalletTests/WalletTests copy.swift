//
//  WalletTests.swift
//  WalletTests
//
//  Created by Ronald Mannak on 10/10/21.
//

import XCTest
import HDWalletKit
@testable import Wallet

class WalletTests: XCTestCase {
    
    let mnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    let password = "password123"
    var manager: WalletManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAccounts()
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
    
    func testSaveAccounts() async throws {
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let generatedAccounts = await wallet.generateAccounts(count: 5).map { $0.address }
        let filename = try await manager.saveHDWallet(mnemonic: mnemonic, password: password)
        let recoveredAccounts = try await manager.loadAccounts(name: filename)
        XCTAssertEqual(generatedAccounts, recoveredAccounts)
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
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: password)
        
        let restoredWallet = try await manager.loadHDWallet(name: name, password: password)
        XCTAssertEqual(wallet, restoredWallet)
    }

}
