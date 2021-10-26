//
//  WalletTests.swift
//  WalletTests
//
//  Created by Ronald Mannak on 10/10/21.
//

import XCTest
import MEWwalletKit
@testable import Balance

class KeychainTests: XCTestCase {
    
    var passwordItem: KeychainPasswordItem!
    let password = "password123"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                account: "unitTestWallet",
                                                accessGroup: KeychainConfiguration.accessGroup)
        try passwordItem.deleteItem()
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
    
    func testSaveAndReadPassword() async throws {
        try passwordItem.savePassword(password, userPresence: false)
        let passwordRead = try passwordItem.readPassword()
        XCTAssertEqual(passwordRead, password)
    }
}
