//
//  ContentView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import SwiftUI
import WebKit
import HDWalletKit
#if os(macOS)
import SafariServices
#endif

struct KeychainConfiguration {
    static let serviceName = "Wallet"
    static let accessGroup: String? = nil
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .task {
                print("Hello")
                await createNewHDWallet()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// MARK: -- Test methods


extension ContentView {
    
    
    func createNewHDWallet() async {
        let mnemonic = HDWalletKit.Mnemonic.create()
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
        let address0 = await wallet.generateAddress(at: UInt32(0))
        let address1 = await wallet.generateAddress(at: UInt32(1))
        print("addresses created:")
        print(address0)
        print(address1)
//        return Account(coin: coin, index: index, address: address, displayName: "")
    }
    
    func saveFile() {
        
        Task {
            do {
                
                let document = try SharedDocument(filename: "testfile.txt")
                try await document.write("this is a test file".data(using: .utf8)!)
                                
            } catch {
                fatalError("File error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveAndReadPassword() {
        // Test to save a password to the keychain, which the extension should be able to read.
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: "wallet2",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.deleteItem()
            
            // Save the password for the new item.
            try passwordItem.savePassword("password123", userPresence: true)
            // Just making sure we can read it
            let passwordRead = try passwordItem.readPassword()
            guard passwordRead == "password123" else {
                print("cannot read password")
                return
            }
            print("password is \(passwordRead)")
        } catch {
            fatalError("Error updating keychain - \(error.localizedDescription) code: \((error as NSError).code)")
        }
    }
    
    /*
     From ViewDidLoad:
     self.webView.navigationDelegate = self

#if os(iOS)
     self.webView.scrollView.isScrollEnabled = false
#endif

     self.webView.configuration.userContentController.add(self, name: "controller")

     self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
     
     */

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                webView.evaluateJavaScript("show('mac', \(state.isEnabled)")
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
#if os(macOS)
        if (message.body as! String != "open-preferences") {
            return;
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            guard error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                NSApplication.shared.terminate(nil)
            }
        }
#endif
    }
}
