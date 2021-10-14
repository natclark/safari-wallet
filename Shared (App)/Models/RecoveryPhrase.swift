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
    
    func components() -> [String] {
        return mnemonic.components(separatedBy: " ")
    }
    
    func shufflePhrase() -> [String] {
        return components().shuffled()
    }

    func isEqual(to array: [String]) -> Bool {
        let reconstructedMnemonic = array.joined(separator: " ")
        return reconstructedMnemonic == mnemonic
    }
}
