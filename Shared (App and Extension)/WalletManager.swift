//
//  WalletManager.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/9/21.
//

import Foundation
import MEWwalletKit
//import CryptoSwift

class WalletManager {
    
    // MARK: - Restore wallet
    
    /// Recreates wallet from mnemonic
    /// - Parameters:
    ///   - mnemonic: 12 or 24 word mnemonic as string with single space between words
    /// - Returns: Wallet
    func restoreWallet<P>(mnemonic: String) throws -> Wallet<P> {
        return try restoreWallet(mnemonic: mnemonic.components(separatedBy: " "))
    }
    
    
    /// Recreates wallet from mnemonic
    /// - Parameters:
    ///   - mnemonic: 12 or 24 word mnemonic as an array of strings
    /// - Returns: Wallet
    func restoreWallet<P>(mnemonic: [String]) throws -> Wallet<P> {
        guard let seed = try BIP39(mnemonic: mnemonic).seed() else { throw WalletError.seedError }
        return try Wallet(seed: seed) // Defaults to Ethereum for now
    }

    // MARK: - Save wallet to disk
    
    /// Saves the mnemonic to disk in a KeystoreV3 file format and encrypted by the provided password.
    /// Call SaveAddresses() after saveWallet to store addresses to disk. Save default wallet by calling SetDefaultHDWallet()
    /// - Parameters:
    ///   - mnemonic: 12 or 24 word mnemonic as string with single space between words
    ///   - password: User chosen password
    ///   - storePasswordInKeychain: If true, the password will be stored in the Apple Keychain
    ///   - filename: filename. If nil, a random UUID will be used.
    /// - Returns: the filename
    func saveWallet(mnemonic: String, password: String, storePasswordInKeychain: Bool = true, filename: String = UUID().uuidString) async throws -> String {
        
        // 1. Store HDWallet recovery phrase
        try await saveKeystore(mnemonic: mnemonic, password: password, name: filename)
        
        // 2. Store password in keychain
        if storePasswordInKeychain == true {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: filename,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(password, userPresence: true, reusableDuration: 0)
        }
                
        return filename
    }
    
    /// Internal method to store mnemonic in a standard Keystore V3 file
    /// - Parameters:
    ///   - mnemonic: 12 or 24 word mnemonic as string with single space between words
    ///   - password: User chosen password
    ///   - name: filename
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
    
    // MARK: - Load wallet from disk

    
    /// Loads wallet from disk. Use to sign a transaction
    /// - Parameters:
    ///   - name: filename
    ///   - password: password used to save the file
    ///   - network: defaults to .ethereum
    /// - Returns: Wallet
    func loadWallet(name: String, password: String? = nil, network: Network) async throws -> Wallet<PrivateKeyEth1> {
        let mnemonic = try await loadMnemonic(name: name, password: password)
        return try restoreWallet(mnemonic: mnemonic)
    }
    
    /// Loads mnemonic from disk.
    /// - Parameters:
    ///   - name: filename
    ///   - password: password used to save the file
    /// - Returns: mnemonic as string
    func loadMnemonic(name: String, password: String? = nil) async throws -> String {
        let passwordData = try fetchPassword(account: name, password: password)
        let keystoreData = try await SharedDocument(filename: name.deletingPathExtension().appendPathExtension(HDWALLET_FILE_EXTENSION)).read()
        guard let keystore = try KeystoreV3(keystore: keystoreData), let mnemonicData = try await keystore.getDecryptedKeystore(passwordData: passwordData) else {
            throw WalletError.wrongPassword
        }
        return String(decoding: mnemonicData, as: UTF8.self)
    }
    
    // MARK: - Load and save addresses from and to disk
    
    /// Saves addresses as an array of strings to disk. Set default address in NSUserDefaults by using setDefaultAddress()
    /// - Parameters:
    ///   - mnemonic: Mnemonic of the wallet's addresses to save
    ///   - addressCount: Number of address to generate and save. Always starts with index 0
    ///   - name: filename
    /// - Returns: Array of generated addresses
    func saveAddresses(mnemonic: String, addressCount: Int, name: String) async throws -> [String] {
        let wallet: Wallet<PrivateKeyEth1> = try restoreWallet(mnemonic: mnemonic)
        return try await saveAddresses(wallet: wallet, addressCount: addressCount, name: name)
    }
    
    
    /// Saves addresses as an array of strings to disk. Set default address in NSUserDefaults by using setDefaultAddress()
    /// - Parameters:
    ///   - wallet: wallet
    ///   - addressCount: Number of address to generate and save. Always starts with index 0
    ///   - name: filename
    /// - Returns: Array of generated addresses
    func saveAddresses(wallet: Wallet<PrivateKeyEth1>, addressCount: Int, name: String) async throws -> [String] {
        let addresses = try wallet.generateAddresses(count: addressCount).map { $0.address }
        let addressesJSON = try JSONEncoder().encode(addresses)
        let networkExtension = wallet.privateKey.network.symbol
        let filePath = try name.deletingPathExtension().appendPathExtension(networkExtension).appendPathExtension(ADDRESS_FILE_EXTENSION)
        let addressesFile = try SharedDocument(filename: filePath)
        try await addressesFile.write(addressesJSON)
        return addresses
    }
    
    func loadAddresses(name: String, network: Network = .ethereum) async throws -> [String] {
        let networkExtension = network.symbol
        let addressesFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(networkExtension).appendPathExtension(ADDRESS_FILE_EXTENSION))
        let data = try await addressesFile.read()
        return try JSONDecoder().decode([String].self, from: data)
    }
    
    // MARK: List files
    
    func listWalletFiles() throws -> [String] {
        return try listFiles(filter: HDWALLET_FILE_EXTENSION)
    }
    
    func listAddressFiles(network: Network = .ethereum) throws -> [String] {
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

    // MARK: - Manager state
    func hasAccounts() throws -> Bool {
        return try self.listAddressFiles().count > 0        
    }

    // MARK: - Keychain
    
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
        
    /// Fetches the derived private key belonging to an address
    /// - Parameters:
    ///   - address: address
    ///   - walletName: wallet that address is derived from
    ///   - password: password of the wallet file
    ///   - network: default is .ethereum
    /// - Returns: the private key belonging to address
    func fetchPrivateKeyFor(address: String, walletName: String, password: String? = nil, network: Network = .ethereum) async throws -> PrivateKeyEth1 {
        let wallet = try await loadWallet(name: walletName, password: password, network: network)
        // FIXME: We're only scanning the first 50
        for i in 0 ..< 50 {
            let privateKey = try wallet.derive(network, index: UInt32(i)).privateKey
            guard let generatedAddress = privateKey.address()?.address else { continue }
            if generatedAddress == address {
                return privateKey
            }
        }
        throw WalletError.addressNotFound
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
