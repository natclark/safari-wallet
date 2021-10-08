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
    
    let biometricIDAuth = BiometricIDAuth()

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        if let messageDictionary = message as? [String: String], messageDictionary["message"] == "Connect wallet" {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received Connect wallet message")            
            
//            Task {
//                guard biometricIDAuth.canEvaluatePolicy() else {
//                    os_log(.default, "Safari-wallet SafariWebExtensionHandler: no FaceID/TouchID available")
//                    return
//                }
//                
//                do {
//                    if try await biometricIDAuth.authenticateUser() == true {
//                        os_log(.default, "Safari-wallet SafariWebExtensionHandler: user authenticated")
//                    } else {
//                        os_log(.default, "Safari-wallet SafariWebExtensionHandler: user not authenticated")
//                    }
//                } catch {
//                    os_log("Safari-wallet SafariWebExtensionHandler error: %s", type: .info, error.localizedDescription)
//                    // we get:error "User interaction required."
//                    // Can we transfer the user back to the app and then use touchIDAuthenticationAllowableReuseDuration?
//                    // Seealso: https://medium.com/swlh/get-the-most-out-of-sign-in-with-apple-e7e2ae072882
//                }
//            }
            
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

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

}
