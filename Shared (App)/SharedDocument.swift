//
//  SharedDocument.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/8/21.
//

import Foundation

struct SharedDocument {
    
    let url: URL?
    
    init(filename: String) {
        
        self.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_GROUP)?.appendingPathComponent(filename)
    }
    
    
    
    
}
