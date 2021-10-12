//
//  String.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/10/21.
//

import Foundation

extension String {

    func appendPathExtension(_ fileExt: String) throws -> String {
        
        guard let name = (self as NSString).appendingPathExtension(fileExt) else {
            throw WalletError.invalidInput
        }
        return name
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    func deletingPathExtension() -> String {
        (self as NSString).deletingPathExtension
    }

}
