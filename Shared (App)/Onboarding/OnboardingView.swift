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
    case summary            // Show summary view
    case appIntro           // Show app intro after wallet is created or restored
    case dismiss            // We're done here
}

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var title = "Set up Safari Wallet" // set to "Create new wallet"
    
    /// New mnemonic generated in the onAppear of the title
    @State private var mnemonic: String = ""
    
    /// User provided mnemonic to
//    @State private var restoredMnemonic: String = ""
    
    /// State
    @State private var state: OnboardingState = .initial
    
    /// visible tab index
    @State var tabIndex = 0
    
    var body: some View {
        
        VStack {
            
            if state == .initial {

                // Show Restore or Create Wallet view
                RestoreOrCreateWalletView(state: $state)

            } else if state == .createWallet {

                // Show and confirm new mnemonic
                TabView(selection: $tabIndex) {
                    ShowMnemonicView(state: $state, tabIndex: $tabIndex, mnemonic: RecoveryPhrase(mnemonic: mnemonic))
                        .tag(0)
                    ConfirmMnemonicView(state: $state, tabIndex: $tabIndex, mnemonic: RecoveryPhrase(mnemonic: mnemonic))
                        .tag(1)
//                    CreatePasswordView(state: $state, tabIndex: $tabIndex, mnemonic: mnemonic)
//                    .tag(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .task { self.tabIndex = 0 }

            } else if state == .restoreWallet {

                // Restore existing wallet
//                TabView {
                    RestoreWalletView(state: $state)
//                        .tag(0)
//                    CreatePasswordView(state: $state, tabIndex: $tabIndex, mnemonic: restoredMnemonic)
//                        .tag(1)
//                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .task { self.tabIndex = 0 }
                
            } else if state == .summary {
                
                // Show summary view
                SummaryView(state: $state, tabIndex: $tabIndex)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if state == .appIntro {

                // Show app intro
                TabView {
                    Intro1View(state: $state, tabIndex: $tabIndex)
                        .tag(0)
                    Intro2View(state: $state, tabIndex: $tabIndex)
                        .tag(1)
                    Intro3View(state: $state, tabIndex: $tabIndex)
                        .tag(2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .task { self.tabIndex = 0 }
            } else if state == .dismiss {

                // Dismiss modal view
                Text("").task {
                    presentationMode.wrappedValue.dismiss()
                }                
            }            
        }
        .interactiveDismissDisabled(true)
        .onAppear {
            self.mnemonic = Mnemonic.create()
        }
    }    
}


extension OnboardingView {

}
