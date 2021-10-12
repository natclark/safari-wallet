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

    func beginRequest(with context: NSExtensionContext) {

        let response = NSExtensionItem()
        defer { context.completeRequest(returningItems: [response], completionHandler: nil) }

        // Grab message
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        guard let messageDictionary = message as? [String: String], let message = messageDictionary["message"] else {
            response.userInfo = [SFExtensionMessageKey: ["Error": "Received empty message."]]
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received empty message")
            return
        }
        
        os_log(.default, "Safari-wallet SafariWebExtensionHandler: Received message from browser.runtime.sendNativeMessage: %@", message as CVarArg)
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ] // default response
        
        do {
            let returnValue = try handle(message: message)
            if let returnValue = returnValue {
                response.userInfo = returnValue
            }
        } catch {
            // TODO: error does not always return useful message. Should we return error codes instead?
            response.userInfo = [SFSFExtensionResponseErrorKey: error.localizedDescription]
            os_log(.error, "Safari-wallet SafariWebExtensionHandler: %@", error.localizedDescription as CVarArg)
        }
    }
}

// MARK: - Message handling

extension SafariWebExtensionHandler {
    
    func handle(message: String, parameters: [String: Any]? = nil) throws -> [String: Any]? {
        switch message {
        case "CONNECT_WALLET":
            print("connect wallet")
            return nil
            
        case "GET_CURRENT_ADDRESS":
            // Returns the address currently selected in the containing app and stored in NSUserDefaults
            return [SFSFExtensionReturnValue: self.currentAddress()]
            
        case "GET_CURRENT_HDWALLET":
            // Returns the name of the HD wallet currently selected in the containing app and stored in NSUserDefaults
            // The name is a random UUID by default
            return [SFSFExtensionReturnValue: self.currentHDWallet()]
            /*
        case "LIST_ADDRESSES":
            // Returns the list of addresses generated for current wallet
            return [SFSFExtensionReturnValue: self.listAddresses()]
            
        case "OPEN_WALLET":
            return openWallet(wallet: parameters)
            
        case "SWITCH_TO_ADDRESS":
            return switchAddress(address: parameters)
            
        case "SIGN":
            return sign(rawTx: parameters)*/
            
        default:
            os_log(.default, "Safari-wallet SafariWebExtensionHandler: received unknown command '%@'", message as CVarArg)
            return [SFSFExtensionResponseErrorKey: "Unknown command in message"]
        }
    }
    
}

extension SafariWebExtensionHandler {
    
    func currentAddress() -> String {
        return "TODO: address to return"
    }
    
    func currentHDWallet() -> String {
        return "TODO: wallet to return"
    }
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
