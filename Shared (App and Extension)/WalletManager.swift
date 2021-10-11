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
    
    func createNewHDWallet(mnemonic: String) async  -> Wallet {        
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        return await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
    }
    
    // MARK: - Save and load wallets
    
    func saveHDWallet(mnemonic: String, password: String, accountsCount: Int = 5, name: String = UUID().uuidString) async throws -> String {
        
        // TODO: check if mnemonic is valid?
        
        // 1. Store HDWallet recovery phrase
        try await saveKeystore(mnemonic: mnemonic, password: password, name: name)
        
        // 2. Create Ethereum addresses and store in separate file
//        try await saveAccounts(mnemonic: mnemonic, accountsCount: accountsCount, name: name)
        
        return name
    }
    
    func saveKeystore(mnemonic: String, password: String, name: String) async throws -> Data {
        print("saving mnemonic: \(mnemonic)")
        guard let phraseData = mnemonic.data(using: .utf8),
                let passwordData = password.data(using: .utf8)?.sha256(),
                let keystore = try await KeystoreV3(privateKey: phraseData, passwordData: passwordData)?.encodedData()
        else {
            throw WalletError.invalidInput
        }
        let hdWalletFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(HDWALLET_FILE_EXTENSION))
        try await hdWalletFile.write(keystore)
        return keystore
    }
    
    func loadHDWallet(name: String, password: String) async throws -> Wallet {
        let keystoreData = try await SharedDocument(filename: name.deletingPathExtension().appendPathExtension(HDWALLET_FILE_EXTENSION)).read()
        guard let passwordData = password.data(using: .utf8)?.sha256() else { throw WalletError.invalidPassword }
        guard let keystore = try KeystoreV3(keystore: keystoreData),
                let mnemonicData = try await keystore.getDecryptedKeystore(passwordData: passwordData) else {
                    throw WalletError.keystoreError
                    
                }

        let mnemonic = String(decoding: mnemonicData, as: UTF8.self)
        print("recovered mnemonic: \(mnemonic)")
        let masterSeed = HDWalletKit.Mnemonic.createSeed(mnemonic: mnemonic)
        return await HDWalletKit.Wallet(seed: masterSeed, coin: .ethereum)
    }
    
    private func saveAccounts(mnemonic: String, accountsCount: Int, name: String) async throws {
        let wallet = await Wallet(seed: Mnemonic.createSeed(mnemonic: mnemonic), coin: .ethereum)
        
        let accounts = await wallet.generateAddresses(count: accountsCount)
        let accountsJSON = try JSONEncoder().encode(accounts)
        let accountsFile = try SharedDocument(filename: name.deletingPathExtension().appendPathExtension(ACCOUNTS_FILE_EXTENSION))
        try await accountsFile.write(accountsJSON)
    }
    
    func loadAccounts(name: String) async throws -> [String] {
        fatalError()
        return []
    }
    
    func listWalletFiles() throws -> [String] {
        return try listFiles(filter: HDWALLET_FILE_EXTENSION)
    }
    
    func listAccountFiles() throws -> [String] {
        return try listFiles(filter: ACCOUNTS_FILE_EXTENSION)
    }
    
    func listFiles(filter fileExtension: String? = nil) throws -> [String] {
        let directory = try URL.sharedContainer()
        let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
        
        guard let fileExtension = fileExtension else {
            return files
        }
        return files.filter { $0.pathExtension == fileExtension }
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
        }
    }
    
    func deleteAllAccounts() throws {
        let directory = try URL.sharedContainer()
        let accounts = try listAccountFiles()
        
        for account in accounts {
            try FileManager.default.removeItem(at: directory.appendingPathComponent(account))
        }
    }
}
#endif
