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
        
        // Sanity check
        /*
         
         The returned Promise SHOULD reject if any of the following conditions are met:

         The Provider is disconnected.
         If rejecting for this reason, the Promise rejection error code MUST be 4900.
         The RPC request is directed at a specific chain, and the Provider is not connected to that chain, but is connected to at least one other chain.
         If rejecting for this reason, the Promise rejection error code MUST be 4901.
         
         */
        
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
                /*
                 If an RPC method defined in a finalized EIP is not supported, it SHOULD be rejected with a 4200 error per the Provider Errors section below, or an appropriate error per the RPC method’s specification.
                 */
            }
            
//            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as CVarArg)
            let logger = Logger() //label: "com.starlingprotocol.wallet")
            logger.critical("Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: \(message)")
            do {
                let returnValue = try await handle(message: message)
                response.userInfo = [SFExtensionMessageKey: returnValue]
            } catch {
                response.userInfo = errorResponse(error: error.localizedDescription)
                os_log(.error, "Safari-wallet SafariWebExtensionHandler: %@", error.localizedDescription as CVarArg)
            }
//            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Sending response %@", response.userInfo[SFExtensionMessageKey] as Any)
            logger.critical("Safari-wallet SafariWebExtensionHandler response: \(String(describing: response.userInfo!))")
        }

    }
}

// MARK: - Message handling

extension SafariWebExtensionHandler {
        
    fileprivate func errorResponse(error: String) -> [String: Any] {
        return [SFExtensionMessageKey: [SFSFExtensionResponseErrorKey: error]]
    }
    
    // web3 handler
    func handle(message: String, parameters: [String: Any]? = nil) async throws -> Any {
        
        guard let client = AlchemyClient() else { throw WalletError.gatewayConnectionError }
        guard let walletName = walletManager.defaultWallet else { throw WalletError.noDefaultWalletSet }
        guard let address = walletManager.defaultAddress else { throw WalletError.noDefaultAddressSet }
        
        switch message {
                        
        case "eth_getAccounts", "get_current_address":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults
            return [address]

        case "eth_getBalance":
            // Returns the balance of the currently selected address
            return try await client.ethGetBalance(address: address).description
        
        default:
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received unknown command '%@'", message as CVarArg)
            return [SFSFExtensionResponseErrorKey: "Unknown command in message"]
            /*
             If an RPC method defined in a finalized EIP is not supported, it SHOULD be rejected with a 4200 error per the Provider Errors section below, or an appropriate error per the RPC method’s specification.
             */
        }

    }
    
}
