//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Nathan Clark on 9/30/21.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message"

// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "Wallet"
    static let accessGroup: String? = nil
}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    let walletManager = WalletManager()

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        /*
        let response = NSExtensionItem()
//        defer { context.completeRequest(returningItems: [response], completionHandler: nil) } // does response update or gets captured
        guard let messageDictionary = message as? [String: String], let message = messageDictionary["message"] else {
            context.completeRequest(returningItems: [response], completionHandler: nil)
            return
        }
        
        if message == "Connect Wallet" {
            
        else if message == "current addresses" {
            
        } else if message == "List addresses" {
            
        } */
        
        if let messageDictionary = message as? [String: String], messageDictionary["message"] == "Connect wallet" {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received Connect wallet message")            
        
            Task {
                do {
                    try await self.readAddresses()
                    try await self.readWallets()
                } catch {
                    os_log(.default, "Safari-wallet SafariWebExtensionHandler: error %@", error.localizedDescription)
                }
            }
            
//            readFile()
//           readPassword()
        }

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
    
    func readWallets() async throws {
        let manager = WalletManager()
        guard let walletFile = try walletManager.listWalletFiles().first else {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: no wallet files")
            return
        }
        let wallet = try await manager.loadHDWallet(name: walletFile, password: "password123")
        let addresses =  await wallet.generateAddresses()
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: %@", addresses)
    }
    
    func readFile() {
        Task {
            do {
                
                let document = try SharedDocument(filename: "testfile.txt")
                let data = try await document.read()
                os_log(.default, "Safari-wallet SafariWebExtensionHandler: read file %@", String(data: data, encoding: .utf8)!)
            } catch {
                fatalError("File error: \(error.localizedDescription)")
            }
        }
    }

    func readPassword() {
        // Read password set by containing app
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: "wallet2",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Read password
            let passwordRead = try passwordItem.readPassword()
            if passwordRead == "password123"  {
                os_log(.default, "Safari-wallet SafariWebExtensionHandler: found correct password")
            } else {
                os_log(.default, "Safari-wallet SafariWebExtensionHandler: read wrong password")
            }
            
        } catch {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: no password")
        }
    }
    
    func readAddresses() async throws {
        
        guard let addressFile = try walletManager.listAddressFiles().first else {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: no address files")
            return
        }
        let addresses = try await walletManager.loadAddresses(name: addressFile)
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: %@", addresses)
    }
}
