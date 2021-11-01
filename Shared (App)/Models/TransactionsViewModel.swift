//
//  TransactionsViewModel.swift
//  Wallet
//
//  Created by Nathan Clark on 10/30/21.
//

import Foundation
import Combine
import Alamofire

class TransactionsViewModel: ObservableObject {
    @Published var transactions = [Transaction]()

    init(chain: String, address: String, currency: String, symbol: String) {
        retrieveTransactionsAll(chain: chain, address: address, currency: currency, symbol: symbol)
    }
    
    func retrieveTransactionsAll(chain: String, address: String, currency: String, symbol: String) {

        let req = AF.request(
            "https://api.covalenthq.com/v1/\(chain)/address/\(address)/transactions_v2/",
            method: .get,
            parameters: [
                "key": covalentKey,
                "quote-currency": currency
            ]
        )

        req.responseJSON { res in
            var transactions: [Transaction] = []
            if let json = res.value as? [String: Any] {
                if let data = json["data"] as? [String: Any] {
                    if let items = data["items"] as? [[String: Any]] {
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        for item in items {
                            var tx = Transaction()

                            tx.block_signed_at = dateformatter.date(from: (item["block_signed_at"] as? String)!)!
                            tx.block_height = item["block_height"] as? Int
                            tx.tx_hash = item["tx_hash"] as? String
                            tx.tx_offset = item["tx_offset"] as? Int
                            tx.successful = item["successful"] as? Bool
                            tx.from_address = item["from_address"] as? String
                            tx.from_address_label = item["from_address_label"] as? String
                            tx.to_address = item["to_address"] as? String
                            tx.to_address_label = item["to_address_label"] as? String
                            tx.value = item["value"] as? String
                            tx.value_quote = item["value_quote"] as? Double
                            tx.gas_offered = item["gas_offered"] as? Double
                            tx.gas_spent = item["gas_spent"] as? Double
                            tx.gas_price = item["gas_price"] as? Double
                            tx.gas_quote = item["gas_quote"] as? Double
                            tx.gas_quote_rate = item["gas_quote_rate"] as? Double

                            transactions.append(tx)
                        }
                    } else {
                        print("Error fetching transactions. Please check your internet connection.")
                    }
                } else {
                    print("Error fetching transactions. Please check your internet connection.")
                }
            } else {
                print("Error fetching transactions. Please check your internet connection.")
            }
            self.transactions.append(contentsOf: transactions)
        }
    }
}
