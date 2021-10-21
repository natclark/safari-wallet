//
//  JsonRpcError.swift
//  Wallet
//
//  Created by Tassilo von Gerlach on 10/21/21.
//

import Foundation

struct JsonRpcError: Codable, Error {
   
   let code: Int
   let message: String
   
}
