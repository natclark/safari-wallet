//
//  RecoveryPhrase.swift
//  Wallet (iOS)
//
//  Created by Ronald Mannak on 10/13/21.
//

import Foundation

struct RecoveryPhrase {
    
    /// 12 or 24 word mnemonic with one space between each word
    let mnemonic: String
    let shuffled: [String]
    let shuffledString: String
    
    init(mnemonic: String) {
        self.mnemonic = mnemonic
        self.shuffled = mnemonic.components(separatedBy: " ").shuffled()
        self.shuffledString = shuffled.joined(separator: " ")
    }

    func isEqual(to array: [String]) -> Bool {
        let reconstructedMnemonic = array.joined(separator: " ")
        return reconstructedMnemonic == mnemonic
    }
}
