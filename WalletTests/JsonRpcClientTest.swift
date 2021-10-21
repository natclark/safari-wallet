//
//  JsonRpcClientTest.swift
//  WalletTests
//
//  Created by Tassilo von Gerlach on 10/18/21.
//

import XCTest
@testable import Wallet

@testable import Wallet

class JsonRpcClientTest: XCTestCase {
   
   func testGetBalance() {
      let url: String = "Your_Alchemy_Url"
      let method: String = "eth_getBalance"
      let params = ["Address_you_want_to_get_balance_for",
                    "latest"]
      
      let expextation = self.expectation(description: "Get Balance Expectation")
      
      JsonRpcClient.makeRequest(url: url,
                                method: method,
                                params: params,
                                resultType: String.self) { result in
         switch result {
            case .success(let balance):
               print("Your Account has a balance of \(balance)")
               expextation.fulfill()
            case .failure(let error):
               fatalError("Make sure to set the right url, method, and params \(error)")
         }
      }
      waitForExpectations(timeout: 10, handler: nil)
   }

}
