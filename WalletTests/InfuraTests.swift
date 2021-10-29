//
//  InfuraTests.swift
//  BalanceTests
//
//  Created by Ronald Mannak on 10/26/21.
//

import XCTest
import MEWwalletKit
import BigInt
@testable import Balance

class InfuraTests: XCTestCase {

    var ropstenClient: Client!
    var mainnetClient: Client!
    let uniswapTokenContract = Address(address: "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.ropstenClient = Client(network: .ropsten)
        self.mainnetClient = Client(network: .ethereum)
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
    
    func testBalance() async throws {
        let balance = try await mainnetClient.ethGetBalance(address: "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B", blockNumber: .latest)
        XCTAssertGreaterThan(balance, BigUInt(0))
    }
    
    func testBlockHeight() async throws {
        let height = try await mainnetClient.ethBlockNumber()
        XCTAssertGreaterThan(height, 13_496_430)
    }

}
