//
//  RestoreWalletView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct RestoreWalletView: View {
    
    @Binding var state: OnboardingState
    @State var restoredMnemonic = ""
    @State private var showingPasswordSheet = false
    @State private var walletWasSaved = false
    
    var body: some View {
        
        VStack {
            Text("Restore existing password")
                .font(.title)                
            
            Spacer()
            
            Text("Type in your 12 or 24 word recovery phrase")
            TextField("Recovery phrase", text: $restoredMnemonic)
                .autocapitalization(.none)
            Spacer()
            
            HStack(spacing: 8) {
                Button("Cancel") {
                    state = .initial
                }
                Spacer()
                Button("Next") {
                    showingPasswordSheet = true
                }
                .disabled(RecoveryPhrase(mnemonic: restoredMnemonic.lowercased()).isValid() == false)
                .sheet(isPresented: $showingPasswordSheet) {
                    CreatePasswordView(mnemonic: restoredMnemonic, walletWasSaved: $walletWasSaved)
                        .onDisappear {
                            if walletWasSaved == true {
                                state = .summary
                            }
                        }
                }
            }
            .padding(.bottom, 32)
        }
        .padding()
    }
}

struct RestoreWalletView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .restoreWallet
    static var previews: some View {
        RestoreWalletView(state:$state)
    }
}
