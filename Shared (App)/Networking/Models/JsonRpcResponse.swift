//
//  JsonRpcResponse.swift
//  Wallet
//
//  Created by Tassilo von Gerlach on 10/21/21.
//

import Foundation

struct JsonRpcResponse<Result: Codable>: Codable {
   
   let jsonrpc: String
   let result: Result?
   let error: JsonRpcError?
   let id: Int?
   
}
