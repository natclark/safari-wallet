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
    case keystoreError
}