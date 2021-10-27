//
//  Decimal.swift
//  Balance
//
//  Created by Ronald Mannak on 10/26/21.
//

import Foundation

extension Decimal {
 
    func rounded(_ roundingMode: NSDecimalNumber.RoundingMode = .bankers) -> Decimal {
        var result = Decimal()
        var number = self
        NSDecimalRound(&result, &number, 0, roundingMode)
        return result
    }
    
    var whole: Decimal {
        self < 0 ? rounded(.up) : rounded(.down)
    }
    
    var fraction: Decimal {
        self - whole
    }
}
