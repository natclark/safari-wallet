//
//  Client.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/24/21.
//

import Foundation
import MEWwalletKit
import Network
import BigInt

class Client {
    
    private (set) var isConnected: Bool = false
    
    let jsonRpcClient: JsonRpcClient
//    let baseURL: URL
    let network: Network
    let monitor = NWPathMonitor()
    
    init?(baseURL: ClientBaseURL = .alchemy, network: Network = .ethereum) {
        guard let baseURL = baseURL.baseURL(for: network) else { return nil }
        self.jsonRpcClient = JsonRpcClient(url: baseURL)
//        self.baseURL = baseURL
        self.network = network
        self.monitor.pathUpdateHandler = { self.isConnected = ($0.status == .satisfied) }
        self.monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    deinit {
        self.monitor.cancel()
    }
}

// MARK: - Web3 API
extension Client {
    
    
    /*
     curl https://eth-mainnet.alchemyapi.io/v2/your-api-key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}'
     */
    func ethBlockNumber() async throws -> Int {
        let response = try await jsonRpcClient.makeRequest(method: "eth_blockNumber", resultType: String.self)
        guard let blockHeight = Int(response.stripHexPrefix(), radix: 16) else {
            throw WalletError.unexpectedResponse(response)
        }
        return blockHeight
    }
    
    /*
     curl https://eth-mainnet.alchemyapi.io/v2/your-api-key \
     -X POST \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xc94770007dda54cF92009BFF0dE90c06F603a09f", "latest"],"id":0}'
     */
    func ethGetBalance(address: String, blockNumber: EthereumBlock = .latest) async throws -> BigUInt {
        let result = try await jsonRpcClient.makeRequest(method: "eth_getBalance", params: [address, blockNumber.stringValue], resultType: String.self)
        guard let balance = BigUInt(result.stripHexPrefix(), radix: 16) else { throw WalletError.unexpectedResponse(result) }
        return balance
    }
}
