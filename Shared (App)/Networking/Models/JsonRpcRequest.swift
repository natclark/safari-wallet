//
//  JsonRpcRequest.swift
//  Wallet
//
//  Created by Tassilo von Gerlach on 10/21/21.
//

import Foundation

struct JsonRpcRequest<P: Encodable>: Encodable {
   
   let jsonrpc: String
   let method: String
   let params: P?
   let id: Int
   
   init(method: String, params: P? = nil, id: Int = 1) {
      self.jsonrpc = "2.0"
      self.method = method
      self.params = params
      self.id = id
   }
   
}
