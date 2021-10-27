//
//  WeiTest.swift
//  BalanceTests
//
//  Created by Ronald Mannak on 10/27/21.
//

import XCTest
import BigInt
@testable import Balance

class WeiTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testWei() {
        let balance = Wei(hex: "0x198414ab04d0ceeaf9")!
        XCTAssertEqual(balance, BigInt("470686021792450931449"))
//        gweiBalance = balance.gweiValue
    }
    
    func testGWeiToWei() {
        let balance = GWei(1.2345)
        let weiBalance = balance.weiValue!
        XCTAssertEqual(weiBalance, 1_234_500_000)
        let gweiBalance = weiBalance.gWeiValue
        XCTAssertEqual(gweiBalance, GWei(1.2345))
    }

}
