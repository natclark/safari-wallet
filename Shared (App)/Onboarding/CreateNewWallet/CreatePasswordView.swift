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
    @State var confirmPassword = ""
    
    var body: some View {
        
        VStack {
            Text("Set password")
                .font(.title)
            
            Spacer()
            
//            TextField(
            Text("textfield placeholder")
            Spacer()
            
            HStack(spacing: 8) {
                Button("Previous") {
                    tabIndex -= 1
                }
                Spacer()
                Button("Save wallet") {
                    Task {
                        do {
                            try await createTestWallet()
                        } catch {
                            print("Error creating test wallet: \(error.localizedDescription)")
                        }
                    }
                    state = .summary
                }.disabled(password != confirmPassword)
            }
        }
        .padding()     
    }
}

// MARK: - Wallet methods
extension CreatePasswordView {
    
    func createWallet() async throws {
        let manager = WalletManager()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: self.password)
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        print(addresses)
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
    }
    
    func createTestWallet() async throws {
        let manager = WalletManager()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        print(addresses)
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

