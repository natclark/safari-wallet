//
//  DeveloperView.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/14/21.
//

import SwiftUI
import HDWalletKit

struct DeveloperView: View {
    
    let manager = WalletManager()
    @State var walletCount: Int = 0
    @State var errorMessage: String = ""
    @State var isOnBoardingPresented: Bool = false {
        didSet {
            self.countWallets()
        }
    }
    
    var body: some View {
        VStack {
            
            Text("Developer settings")
                .font(.title)
                .padding()
            
            if walletCount == 0 {
                Text("No wallets found")
            } else if walletCount == 1 {
                Text("1 wallet found")
            } else if walletCount < 1 {
                Text("Could not count wallets: \(errorMessage)")
            } else {
                Text("wallets found: \(walletCount)")
            }
            
            Spacer()
            
            Button("Create a new wallet") {
                isOnBoardingPresented = true
            }
            Text("Shows new wallet popup")
                .padding(.bottom)
            
            Button("Create a new test wallet") {
                Task {
                    do {
                        try await self.createTestWallet()
                    } catch {
                        print("Error creating test wallet: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.top)
            
            Text("Instantly creates a new wallet with the default password 'password123' and makes it the default wallet. Takes up to 5 seconds in debug mode.")
                
            Button("Delete all wallets on disk", role: .destructive) {
                try? manager.deleteAllWallets()
                try? manager.deleteAllAddresses()
                countWallets()
            }
            .padding()
                     
        }
        .padding()
        .onAppear {
            countWallets()
        }
        .sheet(isPresented: $isOnBoardingPresented) { OnboardingView() }
    }
}

extension DeveloperView {
    
    func countWallets() {
        do {
            walletCount = try manager.listWalletFiles().count
        } catch {
            walletCount = -1
            errorMessage = error.localizedDescription
        }
    }
    
    func createTestWallet() async throws {
        let mnemonic = Mnemonic.create()
        let name = try await manager.saveHDWallet(mnemonic: mnemonic, password: "password123")
        let wallet = await manager.createNewHDWallet(mnemonic: mnemonic)
        let addresses = await wallet.generateAddresses()
        print(addresses)
        manager.setDefaultAddress(addresses.first!)
        manager.setDefaultHDWallet(name)
        countWallets()
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
