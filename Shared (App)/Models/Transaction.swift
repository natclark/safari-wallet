//
//  Transaction.swift
//  Wallet
//
//  Created by Nathan Clark on 10/30/21.
//

import Foundation
import SwiftUI

struct Transaction: Codable, Hashable, Identifiable {
    var id = UUID()

    var block_signed_at: Date?
    var block_height: Int?
    var tx_hash: String?
    var tx_offset: Int?
    var successful: Bool?
    var from_address: String?
    var from_address_label: String?
    var to_address: String?
    var to_address_label: String?
    var value: String?
    var value_quote: Double?
    var gas_offered: Double?
    var gas_spent: Double?
    var gas_price: Double?
    var gas_quote: Double?
    var gas_quote_rate: Double?
    // TODO - implement logEvents array
}
