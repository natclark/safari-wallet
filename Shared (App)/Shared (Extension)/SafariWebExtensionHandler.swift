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
            
        case "eth_requestAccounts":
            // Returns the available addresses in the default wallet
            guard let walletName = walletManager.defaultHDWallet() else {
                return [SFSFExtensionResponseErrorKey: "No default wallet set"]
            }
            let addresses = try await walletManager.loadAddresses(name: walletName)
            return [SFExtensionMessageKey: addresses]

        case "get_current_address":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults
            guard let address = walletManager.defaultAddress() else {
                return [SFSFExtensionResponseErrorKey: "No default account set"]
            }
            return [SFExtensionMessageKey: [address]]

        case "get_current_balance":
            // Returns the balance of the currently selected address
            guard let address = walletManager.defaultAddress() else {
                return [SFSFExtensionResponseErrorKey: "No default account set"]
            }
//            guard let balance = walletManager.balanceOf(address) else {
//                return [SFSFExtensionResponseErrorKey: "Balance unavailable"]
//            }
//            return [SFExtensionMessageKey: balance]
            return [SFExtensionMessageKey: 0]

        /*
        case "eth_signTypedData_v3":
            return sign(rawTx: parameters)
        */

        default:
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received unknown command '%@'", message as CVarArg)
            return [SFSFExtensionResponseErrorKey: "Unknown command in message"]
        }

    }
    
}
