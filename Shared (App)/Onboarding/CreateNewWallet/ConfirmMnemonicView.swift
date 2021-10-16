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
//    @Binding var userHasConfirmedRecoveryPhrase: Bool
    
    @State private var userPhrase = [String]() // ordered by user
    @State private var shuffledPhrase: [String]?
        
    private let selectedGridItemLayout = [GridItem(.adaptive(minimum: 100), alignment: .leading)]
    private let shuffledGridItemLayout = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
                
        VStack {
            
            if mnemonic.components.elementsEqual(userPhrase) {
                Text("Recovery phrase reentered correctly")
                    .font(.title)
            } else {
                Text("Reenter the recovery phrase in the correct order")
                    .font(.title)
            }
            
            // MARK: - Grid of user's selected words
            if let _ = self.shuffledPhrase {
                self.userSelectedGrid
            }
            
            Spacer()
            
            // MARK: - Grid of randomly shuffled seed
            if let _ = self.shuffledPhrase, !mnemonic.components.elementsEqual(userPhrase) {
                self.randomlyShuffledGrid
            } else {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
                    .font(.system(size: 60))
                Spacer()
            }
            
                        
            // MARK: - Retry button if the seed is in the wrong order
            if shuffledPhrase?.count == 0 && !mnemonic.components.elementsEqual(userPhrase) {
                Group {
                    Text("The recovery seed is not in the right order.")
                        .foregroundColor(.red)
                    Button(action: {
                        userPhrase = [String]()
                        self.shuffledPhrase = mnemonic.shuffled
                    }) {
                        Text("Retry")
                    }
                }
                .padding()
            } else if mnemonic.components.elementsEqual(userPhrase) {
//                self.userHasConfirmedRecoveryPhrase = true
            }
            
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
//                .disabled(userHasConfirmedRecoveryPhrase == false)
            }
            .padding(.bottom, 32)
        }
        .padding()
        .onAppear {
            self.shuffledPhrase = mnemonic.shuffled
        }
    }
        
    var userSelectedGrid: some View {
                
        let grid = LazyVGrid(columns: selectedGridItemLayout, spacing: 20) {

            ForEach(userPhrase.indices, id: \.self) { i in
                if i < userPhrase.count {
                    Button(action: {
                        self.shuffledPhrase!.append(userPhrase[i])
                        userPhrase.remove(at: i)
                    }) {
                        Label(userPhrase[i], systemImage: "\(i+1).square.fill")
                            .frame(alignment: .leading)
                    }
                    .disabled(mnemonic.components.elementsEqual(userPhrase))
                } else {
                    Label("", systemImage: "\(i+1).square")
                }
            }
        }
        return grid
    }
    
    var randomlyShuffledGrid: some View {
                
        let grid = LazyVGrid(columns: shuffledGridItemLayout, spacing: 20) {
            
            ForEach(0 ..< shuffledPhrase!.count, id: \.self) { i in
                Button(action: {
                    userPhrase.append(shuffledPhrase![i])
                    self.shuffledPhrase!.remove(at: i)
                }) {
                    Text(shuffledPhrase![i])
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                        )
                }
            }
        }.padding()
        return grid
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
