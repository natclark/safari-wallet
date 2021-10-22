//
//  Wallet.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/20/21.
//

import Foundation
import MEWwalletKit

extension Wallet {
    
    static func createNewWallet(bitsOfEntropy: Int = 128, language: BIP39Wordlist = .english, network: Network = .ethereum) throws -> (Wallet, String) {
        let (bip39, wallet) = try Wallet.generate(bitsOfEntropy: bitsOfEntropy, language: language, network: network)
        guard let mnemonicArray = bip39.mnemonic else { throw MEWwalletKit.WalletError.emptySeed }
        let mnemonic = mnemonicArray.joined(separator: " ")
        return (wallet, mnemonic)
    }
    
    static func restoreHDWallet(mnemonic: String, language: BIP39Wordlist = .english, network: Network = .ethereum) throws -> Wallet {
        guard let seed = try BIP39(mnemonic: mnemonic.components(separatedBy: " ")).seed() else { throw MEWwalletKit.WalletError.emptySeed }
        return try Wallet(seed: seed, network: network)
    }
    
    /// Convenience method to generate addresses
    /// - Parameters:
    ///   - count: Number of addresses to be generated
    ///   - network: Network for addresses to be generated (default is Ethereum)
    /// - Returns: Array of addresses
    /// - Throws: WalletError.addressGenerationError if an address couldn't be generated
    func generateAddresses(count: Int, network: Network = .ethereum) throws -> [Address] {
        var addresses = [Address]()
        for i in 0 ..< count {
            guard let address = try self.derive(network, index: UInt32(i)).privateKey.address() else {
                throw WalletError.addressGenerationError
            }
            addresses.append(address)
        }
        return addresses
    }
    
}
