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
        return try data.write(to: url)
    }
}

extension URL {
    
    static func sharedContainerURL(filename: String) throws -> URL {
        
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_GROUP) else { throw WalletError.invalidAppGroupIdentifier }
        #if os(macOS)
        // In MacOS, containerURL:forSecurityApplicationGroupIdentifier returns a URL even if the app group directory is not available
        var isDir : ObjCBool = false
        guard fileManager.fileExists(atPath: container.path, isDirectory:&isDir) == true else {
            throw WalletError.invalidAppGroupIdentifier
        }
        #endif
        
        return container.appendingPathComponent(filename)
    }
}

extension NSFileCoordinator {

    func coordinate(readingItemAt url: URL, options: NSFileCoordinator.ReadingOptions = []) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            var error: NSError?
            NSFileCoordinator().coordinate(readingItemAt: url, options: options, error: &error) { url in
                continuation.resume(returning: url)
            }
            if let error = error { continuation.resume(throwing: error) } // This works because the closure is not invoked in case of an error
        }
    }
    
    func coordinate(writingItemAt url: URL, options: NSFileCoordinator.WritingOptions = []) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            var error: NSError?
            NSFileCoordinator().coordinate(writingItemAt: url, options: options, error: &error) { url in
                continuation.resume(returning: url)
            }
            if let error = error { continuation.resume(throwing: error) } // This works because the closure is not invoked in case of an error
        }
    }
}
