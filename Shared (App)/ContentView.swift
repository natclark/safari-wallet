//
//  ContentView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import SwiftUI
import WebKit
import HDWalletKit
import CryptoSwift
import OSLog
#if os(macOS)
import SafariServices
#endif

//struct KeychainConfiguration {
//    static let serviceName = "com.safari.Wallet"
//    static let accessGroup: String? = nil
//}

struct ContentView: View {
    
    @Binding var isOnBoardingPresented: Bool
    
    var body: some View {
        VStack {
            
            Text("placeholder for DeFi shortcuts")
                .padding()
                .sheet(isPresented: $isOnBoardingPresented) { OnboardingView() }
                        
            EmptyView()
                .padding()
                .task {
                    do {
                        print("Hello")
                        try await createTestWallet()
                    } catch {
                        print("error: \(error)")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var onboarding = false
    static var previews: some View {
        ContentView(isOnBoardingPresented: $onboarding)
    }
}


// MARK: -- Test methods

extension ContentView {
    
    
    func createTestWallet() async throws {
        let mnemonic = Mnemonic.create()
        let manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAddresses()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")
                
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        print(addresses)
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
    }
    
    /*
    func writeAndReadAccounts() async throws {
        let mnemonic = Mnemonic.create()
        let manager = WalletManager()
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let generatedAccounts = await wallet.generateAccounts(count: 5).map { $0.address }
        let filename = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")
        let recoveredAccounts = try await manager.loadAccounts(name: filename)
        if generatedAccounts == recoveredAccounts {
            print("items loaded correctly")
        } else {
            print("error accounts")
        }
    }
    
    func encryptAndDecryptWallet() async throws {
        let data = Data("abandon amount liar amount expire adjust cage candy arch gather drum buyer".utf8)
        let passwordData =  Data("password123".utf8)
        let keystore = try await KeystoreV3(privateKey: data, passwordData: passwordData)
        guard let decoded = try await keystore?.getDecryptedKeystore(passwordData: passwordData) else {
            throw WalletError.invalidInput
        }
        if decoded == data {
            print("data is equal")
        } else {
            print("data is not equal")
        }
    }
    
    func encryptAndDecryptWalletEncoded() async throws {
                
        let data = Data("abandon amount liar amount expire adjust cage candy arch gather drum buyer".utf8)
        let passwordData =  Data("qwertyui".utf8).sha256()
        guard let keystore = try await KeystoreV3(privateKey: data, passwordData: passwordData) else {
            print("error creating keystore")
            return
        }
        let fileData = try keystore.encodedData()
        guard let recoveredKeystore = try KeystoreV3(keystore: fileData), let decoded = try await recoveredKeystore.getDecryptedKeystore(passwordData: passwordData) else {
            print ("error recovering keystore")
            return
        }
        
        if decoded == data {
            print("mnemonic restored correctly")
        } else {
            print("mnemonic invalid")
        }
    }
    
    func saveAndReadWallet() async throws {
        print("start creating wallet")
        let manager = WalletManager()
        try manager.deleteAllWallets()
        try manager.deleteAllAccounts()
        print("all files deleted")
        
        let mnemonic = HDWalletKit.Mnemonic.create()
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")

        let walletFiles = try manager.listWalletFiles()
        print("wallets:\n \(walletFiles)\n")
        
        let restoredWallet = try await manager.loadHDWallet(name: name, password: "password123")
        guard wallet == restoredWallet else {
            print("restored wallet is not the same")
            return
        }
        print("successfully restored wallet: \(restoredWallet)")
    }
    
    
//    func createNewHDWallet() async {
//        let mnemonic = HDWalletKit.Mnemonic.create()
//        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
//        let wallet = await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
//        wall
//    }
    
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
    } */
    
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
