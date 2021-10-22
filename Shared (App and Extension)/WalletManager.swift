//
//  WalletManager.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import Foundation
import HDWalletKit
import CryptoSwift

//@MainActor
class WalletManager {
    
    func createNewHDWallet(mnemonic: String) async -> Wallet {        
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        return await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
    }
}

// MARK: - Manager state
extension WalletManager {
    func hasAccounts() throws -> Bool {
        return try self.listAddressFiles().count > 0        
    }
}
    
// MARK: - Save and load wallets
extension WalletManager {
    
    func saveHDWallet(mnemonic: String, password: String, storePasswordInKeychain: Bool = true, addressCount: Int = 5, name: String = UUID().uuidString) async throws -> String {
        
        // TODO: we could save the two files concurrently
        
        // 1. Store HDWallet recovery phrase
        try await saveKeystore(mnemonic: mnemonic, password: password, name: name)
        
        // 2. Store password in keychain
        if storePasswordInKeychain == true {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: name,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(password, userPresence: true, reusableDuration: 0)
        }
        
        // 3. Create Ethereum addresses and store in separate file
        try await saveAddresses(mnemonic: mnemonic, addressCount: addressCount, name: name)
        
        return name
    }
    
    private func saveKeystore(mnemonic: String, password: String, name: String) async throws {
        guard let phraseData = mnemonic.data(using: .utf8),
                let passwordData = password.data(using: .utf8)?.sha256(),
                let keystore = try await KeystoreV3(privateKey: phraseData, passwordData: passwordData)?.encodedData()
        else {
            throw WalletError.invalidInput
        }
        let hdWalletFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(HDWALLET_FILE_EXTENSION))
        try await hdWalletFile.write(keystore)
    }
    
    func loadMnemonic(name: String, password: String? = nil) async throws -> String {
        let passwordData = try fetchPassword(account: name, password: password)
        let keystoreData = try await SharedDocument(filename: name.deletingPathExtension().appendPathExtension(HDWALLET_FILE_EXTENSION)).read()
        guard let keystore = try KeystoreV3(keystore: keystoreData), let mnemonicData = try await keystore.getDecryptedKeystore(passwordData: passwordData) else {
            throw WalletError.wrongPassword
        }
        return String(decoding: mnemonicData, as: UTF8.self)
    }
    
    func loadMasterPrivateKey(name: String, password: String? = nil, coin: Coin) async throws -> PrivateKey {
        let mnemonic = try await loadMnemonic(name: name, password: password)
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        return await PrivateKey(seed: seed, coin: coin)
    }
    
    /// If this method throws an .invalidPassword error when password is nil, the password stored in the keychain is incorrect
    /// - Parameters:
    ///   - name: <#name description#>
    ///   - password: <#password description#>
    /// - Returns: <#description#>
    func loadHDWallet(name: String, password: String? = nil) async throws -> Wallet {
        let mnemonic = try await loadMnemonic(name: name, password: password)
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        return await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
    }

    private func fetchPassword(account: String, password: String?) throws -> Data {
        if let password = password, let data = password.data(using: .utf8)?.sha256() {
            return data
        } else {
            return try fetchPasswordFromKeychain(account: account)
        }
    }
    
    // Search keychain for stored password
    private func fetchPasswordFromKeychain(account: String) throws -> Data {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: account, accessGroup: KeychainConfiguration.accessGroup)
        let password = try passwordItem.readPassword()
        guard let data = password.data(using: .utf8)?.sha256()  else {
            throw WalletError.invalidPassword
        }
        return data
    }
    
    private func saveAddresses(mnemonic: String, addressCount: Int, name: String) async throws {
        let wallet = await Wallet(seed: Mnemonic.createSeed(mnemonic: mnemonic), coin: .ethereum)
        
        let addresses = await wallet.generateAddresses(count: addressCount)
        let addressesJSON = try JSONEncoder().encode(addresses)
        let addressesFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(ADDRESS_FILE_EXTENSION))
        try await addressesFile.write(addressesJSON)
    }
    
    func loadAddresses(name: String) async throws -> [String] {
        let addressesFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(ADDRESS_FILE_EXTENSION))
        let data = try await addressesFile.read()
        return try JSONDecoder().decode([String].self, from: data)
    }
    
    func listWalletFiles() throws -> [String] {
        return try listFiles(filter: HDWALLET_FILE_EXTENSION)
    }
    
    func listAddressFiles() throws -> [String] {
        return try listFiles(filter: ADDRESS_FILE_EXTENSION)
    }
    
    private func listFiles(filter fileExtension: String? = nil) throws -> [String] {
        let directory = try URL.sharedContainer()
        let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
        
        guard let fileExtension = fileExtension else {
            return files
        }
        return files.filter { $0.pathExtension == fileExtension }
    }
    
    func fetchPrivateKeyFor(address: String, walletName: String, password: String? = nil, coin: Coin = .ethereum) async throws -> PrivateKey {
        let addresses = try await loadAddresses(name: walletName)
        guard let index = addresses.firstIndex(of: address) else {
            throw WalletError.addressNotFound
        }
        let masterKey = try await loadMasterPrivateKey(name: walletName, password: password, coin: coin)
        let privateKey = try await masterKey.privateKey(index: index)
        guard address == privateKey.publicKey.address else {
            throw WalletError.fileInconsistency
        }
        return privateKey
    }
}

// MARK: - NSUserDefaults
extension WalletManager {
    
    func setDefaultAddress(_ address: String) {
        guard let sharedContainer = UserDefaults(suiteName: APP_GROUP) else { return }
        sharedContainer.set(address, forKey: "DefaultAddress")
        sharedContainer.synchronize()
    }
    
    func defaultAddress() -> String? {
        guard let sharedContainer = UserDefaults(suiteName: APP_GROUP), let address = sharedContainer.string(forKey: "DefaultAddress") else { return nil }
        return address
    }

    func balanceOf(_ address: String) -> Double? {
        // TODO
        let balance = 0.00
        return balance
    }
    
    func setDefaultHDWallet(_ wallet: String) {
        guard let sharedContainer = UserDefaults(suiteName: APP_GROUP) else { return }
        sharedContainer.set(wallet, forKey: "DefaultWallet")
        sharedContainer.synchronize()
    }
    
    func defaultHDWallet() -> String? {
        guard let sharedContainer = UserDefaults(suiteName: APP_GROUP), let wallet = sharedContainer.string(forKey: "DefaultWallet") else { return nil }
        return wallet
    }
}

// MARK: - Debugging methods
#if DEBUG
extension WalletManager {
    
    func deleteAllWallets() throws {
        let directory = try URL.sharedContainer()
        let wallets = try listWalletFiles()
        
        for wallet in wallets {
            try FileManager.default.removeItem(at: directory.appendingPathComponent(wallet))
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: wallet,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.deleteItem()
        }
    }
    
    func deleteAllAddresses() throws {
        let directory = try URL.sharedContainer()
        let addresses = try listAddressFiles()
        
        for address in addresses {
            try FileManager.default.removeItem(at: directory.appendingPathComponent(address))
        }
    }
}
#endif
