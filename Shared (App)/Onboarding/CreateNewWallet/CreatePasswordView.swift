//
//  CreatePasswordView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct CreatePasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var mnemonic: String
    
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var creatingWallet = false
    @Binding var walletWasSaved: Bool
    
    #if DEBUG
    let minimumPasswordLength = 3
    #else
    let minimumPasswordLength = 8
    #endif
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        
        VStack {
            Text("Set password")
                .font(.title)
            
            Spacer()
            
            Text("password must be at least \(minimumPasswordLength) characters long")
            
            SecureField("Enter a password", text: $password)
            
            SecureField("Confirm password", text: $confirmPassword)
            
            Spacer()
            
            HStack(spacing: 8) {
                
                Button("Cancel") {
                    // FIXME: disabled property is ignored 
                    if creatingWallet == false {
                        dismiss()
                    }
                }.disabled(creatingWallet == true)
                
                Spacer()
                
                Button("Save wallet") {
                    Task {
                        do {
                            creatingWallet = true
                            try await createWallet()
                            walletWasSaved = true
                            dismiss()
                            creatingWallet = false
                        } catch {
                            errorMessage = error.localizedDescription
                            showingError = true
                            creatingWallet = false
                        }
                    }
                }
                .disabled(password != confirmPassword || password.count < minimumPasswordLength || creatingWallet == true)
                .alert(isPresented: $showingError) {
                    Alert(
                        title: Text("Error: Unable to save wallet"),
                        message: Text(self.errorMessage)
                    )
                }
            }
            .padding(.bottom, 32)
        }
        .padding()     
    }
}

// MARK: - Wallet methods
extension CreatePasswordView {
    
    func createWallet() async throws {
        let manager = WalletManager()
        let name = try await manager.saveWallet(mnemonic: mnemonic, password: self.password)
        let addresses = try await manager.saveAddresses(mnemonic: mnemonic, addressCount: 5, filename: name)     
        #if DEBUG
        print(addresses)
        #endif
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    @State static var walletWasSaved = false
    static var previews: some View {
        CreatePasswordView(mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer", walletWasSaved: $walletWasSaved)
    }
}

