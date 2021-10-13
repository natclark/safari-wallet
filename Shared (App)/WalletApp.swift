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
                .onOpenURL { url in
                    
                    // try: safari-wallet://sign?tx=0x342af423&y=2
                    guard let host = url.host, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                        print("Invalid URL path missing")
                        return
                    }
                    let params = components.queryItems

                    switch host {
                    case "sign":
                        guard let value = valueForKey("tx", in: params) else {
                            print("")
                            return
                        }
                        print("signing tx \(value)")
                        // Sign view
                        return

//                    case "openwallet":
                    default:
                        print("Invalid url: \(url)")
                    }
                }
        }
    }
    
    func valueForKey(_ key: String, in items: [URLQueryItem]?) -> String? {
        guard let items = items else { return nil }
        for item in items {
            if item.name == key {
                return item.value
            }
        }
        return nil
    }
}
