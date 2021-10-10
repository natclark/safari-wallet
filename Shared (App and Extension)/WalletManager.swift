//
//  WalletManager.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import Foundation
import HDWalletKit

@MainActor
class WalletManager {
    
    func walletsAvailable() -> Bool {
        
        return false
    }
    
    func createNewHDWallet() async  -> Wallet {
        let mnemonic = HDWalletKit.Mnemonic.create()
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
        let address0 = await wallet.generateAddress(at: UInt32(0))
        let address1 = await wallet.generateAddress(at: UInt32(1))
        print("addresses created:")
        print(address0)
        print(address1)
        return wallet
    }
    
    func loadHDWallet(name: String) { //-> Wallet {
    
    }
    
    func saveWallet(wallet: Wallet, name: String = UUID().uuidString) async throws {
        
    }
    
}
