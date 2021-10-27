//
//  Wei.swift
//  Balance
//
//  Created by Ronald Mannak on 10/26/21.
//

import Foundation
import BigInt

typealias Wei = BigUInt // or BigInt??
typealias GWei = Decimal
typealias Ether = Decimal

extension Wei {
    
    // NOTE: calculate wei by 10^18
    static var etherInWei: Decimal { pow(Decimal(10), 18) }
    static var gWeiInWei: Decimal { pow(Decimal(10), 9) }
    
    /// Convert Wei(BInt) unit to Gwei(Decimal) unit
    var gWeiValue: GWei? {
        guard let decimalWei = Decimal(string: self.description) else { return nil }
        return decimalWei / Wei.gWeiInWei
    }
    
    /// Convert Wei(BInt) unit to Ether(Decimal) unit
    var etherValue: Ether? {
        guard let decimalWei = Decimal(string: self.description) else { return nil }
        return decimalWei / Wei.etherInWei
    }
    
    ///Convert Wei to Tokens balance
    func toToken(decimals: Int) -> Ether? {
        guard let  decimalWei = Decimal(string: self.description) else { return nil }
        return decimalWei / pow(10, decimals)
    }
}

extension GWei {
    
    /// Convert Gwei to Wei (for gas)
    var weiValue: Wei? {
        let stringValue =  (self * 1_000_000_000).description
        return BigUInt(stringValue, radix: 10) as Wei?
    }
    
}
