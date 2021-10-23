//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Nathan Clark on 9/30/21.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message"
let SFSFExtensionResponseErrorKey = "error"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    let walletManager = WalletManager()
    
    func beginRequest(with context: NSExtensionContext) {

        // * This is just to allow asynchronous calls:
        Task {
            // Q: since this is a task, how can we be sure the task is completed before the handler is booted out of memory?
            let response = NSExtensionItem()
            defer { context.completeRequest(returningItems: [response], completionHandler: nil) }

            // Parse message
            let item = context.inputItems[0] as! NSExtensionItem
            let message = item.userInfo?[SFExtensionMessageKey]
            guard let messageDictionary = message as? [String: String], let message = messageDictionary["message"] else {
                response.userInfo = errorResponse(error: "Received empty message.")
                os_log(.default, "Safari-wallet SafariWebExtensionHandler: received empty message")
                return
            }
            
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as CVarArg)
            
            do {
                let returnValue = try await handle(message: message)
                response.userInfo = [SFExtensionMessageKey: returnValue]
            } catch {
                response.userInfo = errorResponse(error: error.localizedDescription)
                os_log(.error, "Safari-wallet SafariWebExtensionHandler: %@", error.localizedDescription as CVarArg)
            }
        }

    }
}

// MARK: - Message handling

extension SafariWebExtensionHandler {
    
    func errorResponse(error: String) -> [String: Any] {
        return [SFExtensionMessageKey: [SFSFExtensionResponseErrorKey: error]]
    }
    
    func handle(message: String, parameters: [String: Any]? = nil) async throws -> Any {
        switch message {

        case "GET_CURRENT_ADDRESS":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults
            guard let address = walletManager.defaultAddress() else {
                return [SFSFExtensionResponseErrorKey: "No default account"]
            }
            return [SFExtensionMessageKey: [address]]

        case "GET_CURRENT_BALANCE":
            // Returns the balance of the currently selected address
            guard let address = walletManager.defaultAddress() else {
                return [SFSFExtensionResponseErrorKey: "No default account"]
            }
//            guard let balance = walletManager.balanceOf(address) else {
//                return [SFSFExtensionResponseErrorKey: "Balance unavailable"]
//            }
//            return [SFExtensionMessageKey: balance]
            return [SFExtensionMessageKey: 0]

        /*
        case "OPEN_CONTAINING_APP":
            // Opens the containing iOS app
            let x = await UIApplication().canOpenURL(URL(string: "https://macrumors.com")!)
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Can open URL '%@'", x)
            return [:]
        */

        /*
        case "SIGN_MESSAGE":
            return sign(rawTx: parameters)
        */

        default:
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received unknown command '%@'", message as CVarArg)
            return [SFSFExtensionResponseErrorKey: "Unknown command in message"]
        }

    }
    
}
