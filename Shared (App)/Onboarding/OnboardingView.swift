//
//  OnboardingView.swift
//  Wallet (iOS)
//
//  Created by Ronald Mannak on 10/12/21.
//

import SwiftUI
import HDWalletKit

enum OnboardingState {
    case initial            // Show choice to create new or restore existing wallet
    case createWallet       // Create a new wallet
    case restoreWallet      // Restore existing wallet
    case appIntro           // Show app intro after wallet is created or restored
    case dismiss            // We're done here
}

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var title = "Set up Safari Wallet" // set to "Create new wallet"
    
    /// New mnemonic generated in the onAppear of the title
    @State private var mnemonic: String = ""
    
    /// User provided mnemonic to
    @State private var restoredMnemonic: String = ""
    
    /// State
    @State private var state: OnboardingState = .initial
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .padding()
                .tabViewStyle(PageTabViewStyle())
                .interactiveDismissDisabled(true)
                .onAppear {
                    self.mnemonic = Mnemonic.create()
                }
            
            if state == .initial {

                // Show Restore or Create Wallet view
                RestoreOrCreateWalletView(state: $state)

            } else if state == .createWallet {

                // Show and confirm new mnemonic
                TabView {
                    ShowMnemonicView(state: $state, mnemonic: mnemonic)
                    ConfirmMnemonicView(state: $state, mnemonic: mnemonic)
                    CreatePasswordView(state: $state, mnemonic: mnemonic)
                }

            } else if state == .restoreWallet {

                // Restore existing wallet
                TabView {
                    RestoreWalletView(state: $state, restoredMnemonic: $restoredMnemonic)
                    CreatePasswordView(state: $state, mnemonic: restoredMnemonic)
                }
            } else if state == .appIntro {

                // Show app intro
                TabView {
                    SummaryView(state: $state)
                }
            } else if state == .dismiss {

                // Dismiss modal view
                EmptyView().onAppear {
                    presentationMode.wrappedValue.dismiss()
                }                
            }
            
        }       
    }    
}


extension OnboardingView {

}
