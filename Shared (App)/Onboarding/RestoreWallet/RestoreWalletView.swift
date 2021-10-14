//
//  RestoreWalletView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct RestoreWalletView: View {
    
    @Binding var state: OnboardingState
    @Binding var restoredMnemonic: String
    
    var body: some View {
        Text("Restore existing wallet")
        Button("Continue") {
            // Save wallet            
            state = .summary
        }.disabled(false)
    }
}

struct RestoreWalletView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .restoreWallet
    @State static var restoredMnemonic = "abandon amount liar amount expire adjust cage candy arch gather drum buyer"
    static var previews: some View {
        RestoreWalletView(state:$state, restoredMnemonic: $restoredMnemonic)
    }
}
