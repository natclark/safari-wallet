//
//  SafariWebExtensionHandler.swift
//  Shared (Extension)
//
//  Created by Nathan Clark on 9/30/21.
//

import SafariServices
import os.log

let SFExtensionMessageKey = "message" // rename to command or call?
let SFExtensionMessageParameters = "parameters"
let SFSFExtensionResponseErrorKey = "error"
let SFSFExtensionReturnValue = "return-value"

// Keychain Configuration
//struct KeychainConfiguration {
//    static let serviceName = "Wallet"
//    static let accessGroup: String? = nil
//}

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    let walletManager = WalletManager()
    
    // This version of beginRequest returns a standard reply, great for testing
//    func beginRequest(with context: NSExtensionContext) {
//
//        let item = context.inputItems[0] as! NSExtensionItem
//        let message = item.userInfo?[SFExtensionMessageKey]
//        os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
//        let response = NSExtensionItem()
//        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]
//        context.completeRequest(returningItems: [response], completionHandler: nil)
//
//    }
    
    // This version of beginRequest parses received messages and returns requested info in the reply
    
    func beginRequest(with context: NSExtensionContext) {
      
//        Task {
            // Q: since this is a task, how can we be sure the task is completed before the handler is booted out of memory?
            let response = NSExtensionItem()
            defer { context.completeRequest(returningItems: [response], completionHandler: nil) }

            // Grab message
            let item = context.inputItems[0] as! NSExtensionItem
            let message = item.userInfo?[SFExtensionMessageKey]
            guard let messageDictionary = message as? [String: String], let message = messageDictionary["message"] else {
                response.userInfo = [SFSFExtensionResponseErrorKey: ["Error": "Received empty message."]]
                os_log(.default, "Safari-wallet SafariWebExtensionHandler: received empty message")
                return
            }
            
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as CVarArg)
            response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ] // default response
            
            do {
                let returnValue = try await handle(message: message)
                if let returnValue = returnValue {
                    response.userInfo = returnValue
                }
            } catch {
                // TODO: error does not always return useful message. Should we return error codes instead?
                response.userInfo = [SFSFExtensionResponseErrorKey: error.localizedDescription]
                os_log(.error, "Safari-wallet SafariWebExtensionHandler: %@", error.localizedDescription as CVarArg)
            }
//        }
    } 
}

// MARK: - Message handling

extension SafariWebExtensionHandler {
    
    func handle(message: String, parameters: [String: Any]? = nil) async throws -> [String: Any]? {
        switch message {
        case "CONNECT_WALLET":
            fallthrough
            
        case "GET_CURRENT_ADDRESS":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults
            guard let address = walletManager.defaultAddress() else {
                return [SFSFExtensionResponseErrorKey: "No default account"]
            }
            return [SFSFExtensionReturnValue: address]
                        
        case "GET_CURRENT_HDWALLET":
            // Returns the name of the HD wallet currently selected in the containing app and stored in NSUserDefaults
            // The name is a random UUID by default
            guard let wallet = walletManager.defaultHDWallet() else {
                return [SFSFExtensionResponseErrorKey: "No default wallet"]
            }
            return [SFSFExtensionReturnValue: wallet]

        case "LIST_WALLETS":
            // Returns list of HDWallet files
            let wallets = try walletManager.listWalletFiles()
            return [SFSFExtensionReturnValue: wallets]
                        
        case "LIST_ADDRESSES":
            // Returns the list of addresses generated for current wallet
            guard let wallet = walletManager.defaultHDWallet() else {
                return [SFSFExtensionResponseErrorKey: "No default wallet"]
            }
            let addresses = try await walletManager.loadAddresses(name: wallet)
            return [SFSFExtensionReturnValue: addresses]

        case "OPEN_CONTAINING_APP":
            // Opens the containing iOS app
            let x = await UIApplication().canOpenURL(URL(string: "https://macrumors.com")!)
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: Can open URL '%@'", x)
            return [:]
//            openur

        case "SIGN_RAW_TX":
            // Sign transaction
            return [:]
        
//        case "OPEN_WALLET":
//            return openWallet(wallet: parameters)
//
//        case "SWITCH_TO_ADDRESS":
//            return switchAddress(address: parameters)
//
//        case "SIGN":
//            return sign(rawTx: parameters)
            
        default:
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received unknown command '%@'", message as CVarArg)
            return [SFSFExtensionResponseErrorKey: "Unknown command in message"]
        }
    }
    
}

extension SafariWebExtensionHandler {
    
    
}
    /*
    func readWallets() async throws {
        let manager = WalletManager()
        guard let walletFile = try walletManager.listWalletFiles().first else {
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: no wallet files")
            return
        }
        let wallet = try await manager.loadHDWallet(name: walletFile) //, password: "password123")
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
*/

/// Conforming to this protocol allows for URL handling
protocol URLHandler {
    /// Handle a URL
    ///
    /// - Parameter url: The propagated url
    /// - Returns: The handled status
    func handleURL(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

// MARK: - Error Propagation
extension UIResponder {
    /// Propagates a URL through the responder chain.
    ///
    /// - Parameters:
    ///   - url: The URL to propagate
    ///   - options: A dictionary of options to use when opening the URL. For a list of possible keys to include in this dictionary, see URL Options.
    ///   - completion: The block to execute with the results. Provide a value for this parameter if you want to be informed of the success or failure of opening the URL.
    func propagateURL(_ url: URL,
                      options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:],
                      completionHandler completion: ((Bool) -> Void)? = nil) {
        // Check if we have a next, otherwise return `false` to indicate that the operation failed
        guard next != nil else {
            completion?(false)
            return
        }
        // Check if the next responder can handle URLs
        guard let urlHandler = next as? URLHandler else {
            // If not then carry on the propagation of the URL
            next?.propagateURL(url, options: options, completionHandler: completion)
            return
        }
        
        // Ask the Next to handle the URL
        urlHandler.handleURL(url, options: options) { [weak self] (status) in
            if status == false {
                // If the next failed to handle the URL, continue the propagation of the URL
                self?.next?.propagateURL(url, options: options, completionHandler: completion)
            }
        }
    }
}


