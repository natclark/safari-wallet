//
//  ContentView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import SwiftUI
import WebKit
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

        ZStack {
            Text("")
            .sheet(isPresented: $isOnBoardingPresented) { OnboardingView() }

            TabView {
                ShortcutView()
                    .tabItem { Label("Shortcuts", systemImage: "square.grid.3x2") }
                TransactionsView(Transactions: TransactionsViewModel(chain: "1", address: "ric.eth", currency: "USD", symbol: "$"))
                    .tabItem { Label("Transactions", systemImage: "repeat") }
                #if DEBUG
                DeveloperView()
                    .tabItem { Label("Developer", systemImage: "exclamationmark.triangle.fill") }
                #endif                
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
