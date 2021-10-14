//
//  RestoreOrCreateWalletView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct RestoreOrCreateWalletView: View {
    
    @Binding var state: OnboardingState
    
    var body: some View {
        Text("Restore or create wallet")
        
        VStack(spacing: 8) {
            
            Button("Create a new wallet") {
                state = .createWallet
            }
    
            Button("Restore existing wallet") {
                state = .restoreWallet
            }
            
            Text("Needed: 12 or 24 word recovery phrase")
        }
        
    }
}

struct RestoreOrCreateWalletView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .initial
    static var previews: some View {
        RestoreOrCreateWalletView(state: $state)
    }
}
