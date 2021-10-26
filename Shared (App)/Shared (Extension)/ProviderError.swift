//
//  ProviderError.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/25/21.
//

import Foundation

struct ProviderError: Codable {
    let statusCode: Int
    let name: String
    
    static func errorFor(code: Int) -> ProviderError {
        switch code {
        case 4001:
            return ProviderError(statusCode: 4001, name: "User Rejected Request")
        case 4100:
            return ProviderError(statusCode: 4100, name: "Unauthorized")
        case 4200:
            return ProviderError(statusCode: 4200, name: "Unsupported Method")
        case 4900:
            return ProviderError(statusCode: 4900, name: "Disconnected")
        case 4901:
            return ProviderError(statusCode: 4901, name: "Chain Disconnected")
        default:
            return ProviderError(statusCode: -1, name: "Unknown Error")
        }
    }
}
