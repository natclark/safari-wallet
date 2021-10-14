//
//  ConfirmMnemonicView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/13/21.
//

import SwiftUI

struct ConfirmMnemonicView: View {
    
    @Binding var state: OnboardingState
    var mnemonic: String
    
    var body: some View {
        Text("Confirm mnemonic")
    }
}

struct ConfirmMnemonicView_Previews: PreviewProvider {
    @State static var state: OnboardingState = .createWallet
    static var previews: some View {
        ConfirmMnemonicView(state:$state, mnemonic: "abandon amount liar amount expire adjust cage candy arch gather drum buyer")
    }
}
