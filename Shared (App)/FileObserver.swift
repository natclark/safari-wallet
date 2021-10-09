//
//  FileObserver.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/8/21.
//

import Foundation

// Just leaving this here (like, literally). If we need messaging between the extension and the containing app, we can create a file observer on a messages directory 
class FileObserver: NSObject, NSFilePresenter {
    
    var presentedItemURL: URL?
    
    var presentedItemOperationQueue: OperationQueue = OperationQueue.main
            
    init(path: String) throws {
        presentedItemURL = try URL.sharedContainerURL(filename: path)
    }
    
    func presentedItemDidChange() {
        // we received a message
    }
    
}
