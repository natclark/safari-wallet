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
        
    var body: some View {
        
        VStack {
            Text("Restore existing password")
                .font(.title)                
            
            Spacer()
            
            Text("Type in your 12 or 24 word recovery phrase")
            TextField("Recovery phrase", text: $restoredMnemonic)
            Spacer()
            
            HStack(spacing: 8) {
                Button("Cancel") {
                    state = .initial
                }
                Spacer()
                Button("Next") {
                    // TODO: check validity of mnemonic
//                    tabIndex += 1
                    print("done")
                }.disabled(RecoveryPhrase(mnemonic: restoredMnemonic).isValid() == false)
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
