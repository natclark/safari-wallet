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
        
        // TODO: can we fire a timer here that keeps checks on changes (e.g. account)?
        
        Task {
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
    
    fileprivate func errorResponse(error: String) -> [String: Any] {
        return [SFExtensionMessageKey: [SFSFExtensionResponseErrorKey: error]]
    }
    
//    fileprivate func createResponse(value: Any) -> [String: Any] {
//        return [SFExtensionMessageKey: value]
//    }
    // web3 provider
    func handle(message: String, parameters: [String: Any]? = nil) async throws -> Any {
        
        guard let walletName = walletManager.defaultWallet else {
            throw WalletError.noDefaultWalletSet
        }
        guard let address = walletManager.defaultAddress else {
            throw WalletError.noDefaultAddressSet
        }
        
        switch message {
                        
        case "init":
            // Returns initial values for current address and network
            return [
                "defaultAddress": address,
//                "network": walletManager.network.chainID
            ]
            
        case "eth_requestAccounts":
            // Returns the available addresses in the default wallet
            
            let addresses = try await walletManager.loadAddresses(name: walletName)
            return addresses

        case "get_current_address":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults

            return [address]

        case "get_current_balance":
            // Returns the balance of the currently selected address
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
    // since we can't
}

/* Supported Metamask calls
 
 ethereum.networkVersion
 ethereum.selectedAddress
 eth_requestAccounts
 eth_sendTransaction
 */
