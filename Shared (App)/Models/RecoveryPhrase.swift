//
//  RecoveryPhrase.swift
//  Wallet (iOS)
//
//  Created by Ronald Mannak on 10/13/21.
//

import Foundation
import MEWwalletKit

struct RecoveryPhrase {
    
    /// 12 or 24 word mnemonic with one space between each word
    let mnemonic: String
    let components: [String]
    let shuffled: [String]
    let shuffledString: String
    
    init(mnemonic: String) {
        self.mnemonic = mnemonic
        self.components = mnemonic.components(separatedBy: " ")
        self.shuffled = components.shuffled()
        self.shuffledString = shuffled.joined(separator: " ")
    }

    func isEqual(to array: [String]) -> Bool {
        let reconstructedMnemonic = array.joined(separator: " ")
        return reconstructedMnemonic == mnemonic
    }
    
    func isValid(language: BIP39Wordlist = .english) -> Bool {
        
        let wordCount = mnemonic.components(separatedBy: " ").count
        guard wordCount == 12 || wordCount == 24 else { return false }

        // FIXME: 
//        guard components.allSatisfy({ language.words.contains($0.lowercased()) }) == true else { return false }
        
        return true
    }
}
