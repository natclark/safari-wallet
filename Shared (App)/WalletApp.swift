//
//  WalletApp.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import Foundation

import SwiftUI

@main
struct WalletApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
