//
//  URL.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/10/21.
//

import Foundation

extension URL {
    
    static func sharedContainerURL(filename: String) throws -> URL {
        let container = try sharedContainer()
        return container.appendingPathComponent(filename)
    }
    
    static func sharedContainer() throws -> URL {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_GROUP) else { throw WalletError.invalidAppGroupIdentifier }
        #if os(macOS)
        // In MacOS, containerURL:forSecurityApplicationGroupIdentifier returns a URL even if the app group directory is not available
        var isDir : ObjCBool = false
        guard fileManager.fileExists(atPath: container.path, isDirectory:&isDir) == true else {
            throw WalletError.invalidAppGroupIdentifier
        }
        #endif
        return container
    }
}
