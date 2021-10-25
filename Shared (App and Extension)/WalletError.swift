//
//  WalletError.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/8/21.
//

import Foundation

enum WalletError: Error {
    case invalidAppGroupIdentifier
    case invalidInput
    case invalidPassword
    case wrongPassword
    case keystoreError
    case addressNotFound
    case fileInconsistency
    case addressGenerationError
    case seedError
    case noDefaultWalletSet
    case noDefaultAddressSet
    case unexpectedResponse(String)
}
