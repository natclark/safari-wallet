//
//  RestoreWalletView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct RestoreWalletView: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    @Binding var restoredMnemonic: String
        
    var body: some View {
        
        VStack {
            Text("Restore existing password")
                .font(.title)                
            
            Spacer()
            
//            TextField(
            Text("textfield placeholder")
            Spacer()
            
            HStack(spacing: 8) {
                Button("Cancel") {
                    state = .initial
                }
                Spacer()
                Button("Next") {
                    // TODO: check validity of mnemonic
                    tabIndex += 1
                }.disabled(false)
            }
        }
        .padding()
    }
}

struct RestoreWalletView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .restoreWallet
    @State static var tabIndex: Int = 1
    @State static var restoredMnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    static var previews: some View {
        RestoreWalletView(state:$state, tabIndex: $tabIndex, restoredMnemonic: $restoredMnemonic)
    }
}
