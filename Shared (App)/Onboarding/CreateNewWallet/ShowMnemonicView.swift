//
//  ShowMnemonicView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct ShowMnemonicView: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    var mnemonic: String
    
    var body: some View {
        
        VStack {
            Text("Your wallet's recovery phrase")
                .font(.title)
            
            Text("Write down the displayed recovery phrase in the order shown, and store the paper in a secure place. The only way to regain access to your wallet is by reentering the recovery phrase.")
                .padding()
            
            Spacer()
            
            Text(mnemonic)
            Spacer()
            
            HStack(spacing: 8) {
                Button("Cancel") {
                    state = .initial
                }
                Spacer()
                Button("Next") {
                    tabIndex += 1
                }
            }
        }
        .padding()    
    }
}

struct ShowMnemonicView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    @State static var tabIndex: Int = 0
    static var previews: some View {
        ShowMnemonicView(state: $state, tabIndex: $tabIndex, mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    }
}
