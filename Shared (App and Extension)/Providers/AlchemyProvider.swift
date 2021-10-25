//
//  AlchemyProvider.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/24/21.
//

import Foundation
import MEWwalletKit

final class AlchemyProvider: Provider {
        
    init?(network: Network = .ethereum) {
        super.init(baseURL: .alchemy, network: network)
    }
    
    // TODO: Add Alchemy-only web3 functions
}
