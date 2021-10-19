//
//  JsonRpcClient.swift
//  Wallet (iOS)
//
//  Created by Tassilo von Gerlach on 10/18/21.
//

import Foundation

struct JsonRpcRequest<P: Encodable>: Encodable {
   
   let jsonrpc: String
   let method: String
   let params: P?
   let id: String
   
   init(method: String, params: P? = nil, id: String = "1") {
      self.jsonrpc = "2.0"
      self.method = method
      self.params = params
      self.id = id
   }
   
}

struct JsonRpcError: Codable, Error {
   
   let code: Int
   let message: String
   
}

struct JsonRpcResponse<Result: Decodable>: Decodable {
   
   let jsonrpc: String
   let result: Result?
   let error: JsonRpcError?
   let id: String
   
}

enum NetworkError: Error {
   case invalidUrl
   case jsonRpcError(JsonRpcError)
   case requestError(Error)
   case missingData
   case decodingError
   case encodingError
   case unknown
}

class JsonRpcClient {
   
   static func makeRequest<P: Encodable, R: Decodable>(url: String,
                                                       method: String,
                                                       params: P,
                                                       resultType: R.Type,
                                                       urlSession: URLSession = URLSession.shared,
                                                       completion: @escaping (Result<R, NetworkError>) -> Void) {
      guard let url = URL(string: url) else {
         completion(.failure(.invalidUrl))
         return
      }
      
      var urlRequest = URLRequest(url: url,
                                  cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
      urlRequest.httpMethod = "POST"
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
      
      
      let rpcRequest = JsonRpcRequest<P>(method: method, params: params)
      guard let body = try? JSONEncoder().encode(rpcRequest) else {
         completion(.failure(.encodingError))
         return
      }
      urlRequest.httpBody = body
      
      let task = urlSession.dataTask(with: urlRequest) { data, respose, error in
         if let error = error {
            completion(.failure(.requestError(error)))
            return
         }
         
         guard let data = data else {
            completion(.failure(.missingData))
            return
         }
         
         guard let jsonRpcResponse = try? JSONDecoder().decode(JsonRpcResponse<R>.self, from: data) else {
            completion(.failure(.decodingError))
            return
         }
   
         if let result = jsonRpcResponse.result {
            completion(.success(result))
         } else if let rpcError = jsonRpcResponse.error {
            completion(.failure(.jsonRpcError(rpcError)))
         } else {
            completion(.failure(.unknown))
         }
      }
      task.resume()
   }
   
}
