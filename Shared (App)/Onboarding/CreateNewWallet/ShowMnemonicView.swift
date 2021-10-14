//
//  ShowMnemonicView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct ShowMnemonicView: View {
    
    @Binding var state: OnboardingState
    var mnemonic: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(mnemonic)
            Text("Write down the 12-word recovery phrase and store securely")
            HStack(spacing: 8) {
                
                Button("Cancel") {
                    state = .initial
                }
        
                Button("Continue") {
                    // progress to next tab
                }
            }
        }
    }
}

struct ShowMnemonicView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    static var previews: some View {
        ShowMnemonicView(state: $state, mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    }
}
