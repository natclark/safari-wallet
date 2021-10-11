//
//  SharedDocument.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/8/21.
//

import Foundation

struct SharedDocument {

    let url: URL
    
    init(filename: String) throws {
        url = try URL.sharedContainerURL(filename: filename)
    }
    
    func read() async throws -> Data {
        let url = try await NSFileCoordinator().coordinate(readingItemAt: self.url)
        return try Data(contentsOf: url)
    }
    
    func write(_ data: Data) async throws {
        let url = try await  NSFileCoordinator().coordinate(writingItemAt: self.url)
        return try data.write(to: url, options: .atomic)
    }
}

