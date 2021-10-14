//
//  CreatePasswordView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @Binding var state: OnboardingState
    var mnemonic: String
    @State var password = ""
    
    var body: some View {
        Text("Create password")
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
    static var previews: some View {
        CreatePasswordView(state:$state, mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    }
}

