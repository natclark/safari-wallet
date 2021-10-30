//
//  JsonRpcClientTest.swift
//  WalletTests
//
//  Created by Tassilo von Gerlach on 10/18/21.
//

import XCTest
@testable import Safari_Wallet

class JsonRpcClientTest: XCTestCase {
   
   func testMakeRequest_success() async {
      let url = URL(string: "https://this-is-a-fake-url.io/v2/")!
      let client = JsonRpcClient(url: url)
      let method: String = "eth_getBalance"
      let params = ["0xaed557b8cAac9C457d28E70F1F5B0782FCfEF9C3",
                    "latest"]
      
      let mockURLSession = MockURLSession()
      mockURLSession.dataForRequestStub = {
         let fakeRpcResponse = JsonRpcResponse(jsonrpc: "2.0", result: "a-fake-eth-balance", error: nil, id: 1)
         let data = try! JSONEncoder().encode(fakeRpcResponse)
         return (data, HTTPURLResponse())
      }
      
      let balance = try! await client.makeRequest(method: method, params: params, resultType: String.self, urlSession: mockURLSession)
      XCTAssertEqual(balance, "a-fake-eth-balance")
      XCTAssertTrue(mockURLSession.didCallDataForRequest)
      
      XCTAssertEqual(mockURLSession.request!.httpMethod!, "POST")
      XCTAssertEqual(mockURLSession.request!.value(forHTTPHeaderField: "Content-Type")!, "application/json")
      XCTAssertEqual(mockURLSession.request!.value(forHTTPHeaderField: "Accept")!, "application/json")
   }

}

class MockURLSession: WalletURLSession {
   
   init() {}
   
   var didCallDataForRequest: Bool = false
   
   var dataForRequestStub: () throws -> (Data, URLResponse) = {
      throw NSError(domain: "No custom stub set", code: 0, userInfo: nil)
   }
   
   var request: URLRequest?
   var delegate: URLSessionTaskDelegate?
   
   func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
      self.didCallDataForRequest = true
      self.request = request
      self.delegate = delegate
      return try dataForRequestStub()
   }
   
}
