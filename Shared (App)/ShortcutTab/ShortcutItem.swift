//
//  ShortcutItem.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import Foundation

struct ShortcutItem: Identifiable {
    
    let name: String
    let id: Int
    let url: URL
}
    
extension ShortcutItem {

    func iconURL() -> URL {
        let url = URL(string: "https://s2.coinmarketcap.com/static/img/coins/128x128")!
        return url.appendingPathComponent("\(id)").appendingPathExtension("png")
    }

    static func tokens() -> [ShortcutItem] {
        return [
            ShortcutItem(name: "Uniswap", id: 1027, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Aave", id: 7278, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Maker", id: 1518, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "dYdX", id: 11156, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Yearn", id: 5864, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Curve", id: 6538, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Bancor", id: 1727, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "1Inch", id: 8104, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Fei", id: 8642, url: URL(string: "https://app.gysr.io")!),
            ShortcutItem(name: "Gysr", id: 7661, url: URL(string: "https://app.gysr.io")!),
        ]
    }
}
