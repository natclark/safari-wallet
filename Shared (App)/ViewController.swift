//
//  ViewController.swift
//  Shared (App)
//
//  Created by Nathan Clark on 9/30/21.
//

import WebKit

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController
#endif

let extensionBundleIdentifier = "safari.Wallet.Extension"


// Keychain Configuration
struct KeychainConfiguration {
    static let serviceName = "Wallet"
    static let accessGroup: String? = nil
}


class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!
    
    let biometricIDAuth = BiometricIDAuth()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
#endif

        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
        
        saveFile()
//        saveAndReadPassword()
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
