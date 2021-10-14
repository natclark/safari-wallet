//
//  CreatePasswordView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    var mnemonic: String
    @State var password = ""
    
    var body: some View {
        
        VStack {
            Text("Create password")
            
            HStack(spacing: 8) {
                Button("Cancel") {
                    state = .initial
                }
        
                Button("Continue") {
                    // Save wallet
                    state = .summary
                }.disabled(false)
            }
        }
    }
}

// MARK: - Wallet methods
extension CreatePasswordView {
    
    func createWallet() async throws {
        let manager = WalletManager()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: self.password)
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    @State static var tabIndex: Int = 0
    static var previews: some View {
        CreatePasswordView(state:$state, tabIndex: $tabIndex, mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    }
}

