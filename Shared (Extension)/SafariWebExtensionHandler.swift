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
    static let accessGroup: String? = nil //"safari.Wallet"
}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        if let messageDictionary = message as? [String: String], messageDictionary["message"] == "Connect wallet" {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received Connect wallet message")            
            
            // Read password set by containing app
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: "wallet1",
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

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
