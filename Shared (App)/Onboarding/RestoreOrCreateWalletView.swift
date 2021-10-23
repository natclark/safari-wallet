//
//  RestoreOrCreateWalletView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct RestoreOrCreateWalletView: View {
    
    @Binding var state: OnboardingState
    @State var isCancelable: Bool
    
    var body: some View {
        
        VStack(spacing: 8) {
                        
            Text("Restore or create wallet")
                .font(.title)
            
            Spacer()
            
            Button("Create a new wallet") {
                state = .createWallet
            }
            .padding()
                
            Button("Restore existing wallet") {
                state = .restoreWallet
            }
            
            Text("Needed: 12 or 24 word recovery phrase")
                .font(.footnote)

            if isCancelable {
                Button("Cancel") {
                    state = .dismiss
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
    }
}

struct RestoreOrCreateWalletView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .initial
    static var previews: some View {
        RestoreOrCreateWalletView(state: $state, isCancelable: true)
    }
}
