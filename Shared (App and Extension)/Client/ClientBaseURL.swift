//
//  ProviderBaseURL.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/24/21.
//

import Foundation
import MEWwalletKit

enum ClientBaseURL {
    case infura
    case alchemy
    case custom(baseURL: URL)
    
    func baseURL(for network: Network) -> URL? {
        
        switch self {
        case .infura:
            switch network {
            case .ethereum:
                return URL(string: "https://mainnet.infura.io/v3/")!.appendingPathComponent(infuraMainnetKey)
            case .ropsten:
                return URL(string: "https://ropsten.infura.io/v3/")!.appendingPathComponent(infuraRopstenKey)
            default:
                return nil
            }
        case .alchemy:
            switch network {
            case .ethereum:
                return URL(string: "https://eth-mainnet.alchemyapi.io/v2/")!.appendingPathComponent(alchemyMainnetKey)
            case .ropsten:
                return URL(string: "https://eth-ropsten.alchemyapi.io/v2/")!.appendingPathComponent(alchemyRopstenKey)
            default:
                return nil
            }
        case .custom(baseURL: let url):
            return url
        }
    }
}
