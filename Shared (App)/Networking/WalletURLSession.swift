//
//  WalletURLSession.swift
//  Wallet
//
//  Created by Tassilo von Gerlach on 10/21/21.
//

import Foundation

/*
 * We need to create a custom protocol for the URLSession in order to create mocks for unit tests
 */
protocol WalletURLSession {
   
   func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
   
}

/*
 * We need to create a custom protocol for the URLSession in order to create mocks for unit tests
 */
extension URLSession: WalletURLSession { }
