//
//  HexExtensions.swift
//  web3swift
//
//  Created by Matt Marshall on 09/03/2018.
//  Copyright © 2018 Argent Labs Limited. All rights reserved.
//

import Foundation
import BigInt

public extension BigUInt {
    init?(hex: String) {
        self.init(hex.stripHexPrefix().lowercased(), radix: 16)
    }
}

public extension BigInt {
    init?(hex: String) {
        self.init(hex.stripHexPrefix().lowercased(), radix: 16)
    }
}

public extension Int {
    init?(hex: String) {
        self.init(hex.stripHexPrefix(), radix: 16)
    }
}

//public extension Data {
//    init?(hex: String) {
//        if let byteArray = try? HexUtil.byteArray(fromHex: hex.web3.noHexPrefix) {
//            self.init(bytes: byteArray, count: byteArray.count)
//        } else {
//            return nil
//        }
//    }
//}

public extension String {
    init(bytes: [UInt8]) {
        self.init("0x" + bytes.map { String(format: "%02hhx", $0) }.joined())
    }
}
