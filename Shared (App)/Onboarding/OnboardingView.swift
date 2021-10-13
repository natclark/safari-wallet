//
//  OnboardingView.swift
//  Wallet (iOS)
//
//  Created by Ronald Mannak on 10/12/21.
//

import SwiftUI
import HDWalletKit

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mnemonic: String = ""
    
    var body: some View {
        Button("Dismiss Modal") {
            presentationMode.wrappedValue.dismiss()
        }
        .interactiveDismissDisabled(true)
        .task {
            do {
                try await createWallet()
            } catch {
                print("error: \(error)")
            }
        }
    }    
}

// MARK: - Wallet methods
extension OnboardingView {
    
    func createWallet() async throws {
        self.mnemonic = Mnemonic.create()
        // the code below should be executed later
        let manager = WalletManager()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
        print(addresses)
    }
}
