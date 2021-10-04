//
//  AppDelegate.swift
//  macOS (App)
//
//  Created by Nathan Clark on 9/30/21.
//

import Cocoa
import SafariServices

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Override point for customization after application launch.
        
        let manager = SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: "safari.Wallet.Extension") { state, error in
            guard let state = state else {
                guard state == nil else {
                    print("Error fetching extension state: \(error!.localizedDescription)")
                    return
                }
                print("Unknown error fetching extension state")
                return
            }
            if state.isEnabled == true {
                print("extension is enabled")
            } else {
                print("extension is disabled")
            }
        }
        
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

}
