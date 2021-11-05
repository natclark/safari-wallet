//
//  EthereumAddress.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/17/21.
//

import Foundation

struct EthereumAddress {
   
   let address: String
   let walletName: String
   
   func pathIndex() async throws -> Int {
      let manager = WalletManager()
      let addresses = try await manager.loadAddresses(name: walletName)
      guard let index = addresses.firstIndex(of: self.address) else {
         throw WalletError.addressNotFound
      }
      return index
   }
   
//    func sign(rawTx: EthereumRawTransaction, chainID: EthereumChainID = .mainnet, password: String? = nil) async throws -> Data {
//        let privateKey = try await WalletManager().fetchPrivateKeyFor(address: self.address, walletName: self.walletName, password: password, coin: .ethereum)
//        return try await EIP155Signer(chainId: chainID.rawValue).sign(rawTx, privateKey: privateKey)
//    }
    
}
