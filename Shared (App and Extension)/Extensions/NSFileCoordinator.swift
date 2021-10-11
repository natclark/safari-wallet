//
//  NSFileCoordinator.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/10/21.
//

import Foundation

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
