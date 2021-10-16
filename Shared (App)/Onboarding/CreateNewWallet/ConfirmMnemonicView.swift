//
//  ConfirmMnemonicView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI
import HDWalletKit

struct ConfirmMnemonicView: View {
    
    @Binding var state: OnboardingState
    @Binding var tabIndex: Int
    var mnemonic: RecoveryPhrase
//    var mnemonic: String
//    var shuffledMnemonic: [String]
    
    var body: some View {
        
        
        VStack {
            
            Text("Reenter the recovery phrase in the correct order")
                .font(.title)
            
            Spacer()
            
            Text(mnemonic.shuffledString)
            Text("placeholder for confirmation")
                        
            Spacer()
            
            #if DEBUG
            Text("hint: \(mnemonic.mnemonic)")
                .font(.footnote)
            #endif
            HStack(spacing: 8) {
                Button("Previous") {
                    tabIndex -= 1
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

struct ConfirmMnemonicView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    @State static var tabIndex: Int = 0
    static let mnemonic = RecoveryPhrase(mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    static var previews: some View {
        ConfirmMnemonicView(state:$state, tabIndex: $tabIndex, mnemonic: mnemonic)
    }
}
