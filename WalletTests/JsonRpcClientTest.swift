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
   
   func testGetBalance() async {
      let url: String = "Your_Alchemy_Url"
      let method: String = "eth_getBalance"
      let params = ["0xaed557b8cAac9C457d28E70F1F5B0782FCfEF9C7",
                    "latest"]
      let balance = try! await JsonRpcClient.makeRequest(url: url, method: method, params: params, resultType: String.self)
      print("Your Account has a balance of \(balance)")
   }

}
