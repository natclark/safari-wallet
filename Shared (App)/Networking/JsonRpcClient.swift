//
//  JsonRpcClient.swift
//  Wallet (iOS)
//
//  Created by Tassilo von Gerlach on 10/18/21.
//

import Foundation

struct JsonRpcClient {
   
   enum NetworkError: Error {
      case invalidUrl
      case jsonRpcError(JsonRpcError)
      case decodingError
      case encodingError
      case unknown
   }
    
   let url: URL
   
   func makeRequest<P: Encodable, R: Codable>(method: String,
                                              params: P,
                                              resultType: R.Type,
                                              urlSession: WalletURLSession = URLSession.shared)  async throws -> R {
      
      var urlRequest = URLRequest(url: url,
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
      urlRequest.httpMethod = "POST"
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
      
      let rpcRequest = JsonRpcRequest<P>(method: method, params: params)
      guard let body = try? JSONEncoder().encode(rpcRequest) else {
         throw NetworkError.encodingError
      }
      urlRequest.httpBody = body
      
      let (data, _) = try await urlSession.data(for: urlRequest, delegate: nil)
      let jsonRpcResponse = try JSONDecoder().decode(JsonRpcResponse<R>.self, from: data)

      if let result = jsonRpcResponse.result {
         return result
      } else if let rpcError = jsonRpcResponse.error {
         throw NetworkError.jsonRpcError(rpcError)
      } else {
         throw NetworkError.unknown
      }
   }
   
   func makeRequest<R: Codable>(method: String,
                                resultType: R.Type,
                                urlSession: WalletURLSession = URLSession.shared)  async throws -> R {
      let params: [Bool] = []
      return try await makeRequest(method: method, params: params, resultType: resultType)
   }
   
}
