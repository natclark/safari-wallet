//
//  KeystoreV3.swift
//  HDWalletKit
//
//  Created by Pavlo Boiko on 20.08.18.
//  Copyright © 2018 Essentia. All rights reserved.
//

import Foundation
import CryptoSwift

public enum KeystoreError: Error {
    case keyDerivationError
    case aesError
    case randomBytesErrror
}

public class KeystoreV3 {
    
    public var keystoreParams: KeystoreParamsV3?
        
    ///
    public required init? (privateKey: Data, passwordData: Data) async throws {
        self.keystoreParams = try await encryptDataToStorage(passwordData, data: privateKey)
    }
    
    
    ///
    public required init? (keystore: Data) throws {
        self.keystoreParams = try JSONDecoder().decode(KeystoreParamsV3.self, from: keystore)
    }

    public func encodedData() throws -> Data {
        return try JSONEncoder().encode(keystoreParams)
    }
    
    /// Decode keystore with password
    ///
    /// - Parameter password: encoded password
    /// - Returns: decrypted keystore value
    /// - Throws: wrong password error
    public func getDecryptedKeystore(passwordData: Data) async throws -> Data? {
        guard let keystoreParams = self.keystoreParams else {return nil}
        guard let saltData = Data.fromHex(keystoreParams.crypto.kdfparams.salt) else {return nil}
        let derivedLen = keystoreParams.crypto.kdfparams.dklen
        guard let N = keystoreParams.crypto.kdfparams.n else {return nil}
        guard let P = keystoreParams.crypto.kdfparams.p else {return nil}
        guard let R = keystoreParams.crypto.kdfparams.r else {return nil}
        guard let derivedKey = encryptData(passwordData: passwordData,
                                           salt: saltData,
                                           length: derivedLen,
                                           N: N,
                                           R: R,
                                           P: P) else {return nil}
        var dataForMAC = Data()
        let derivedKeyLast16bytes = Data(derivedKey[(derivedKey.count - 16)...(derivedKey.count - 1)])
        dataForMAC.append(derivedKeyLast16bytes)
        guard let cipherText = Data.fromHex(keystoreParams.crypto.ciphertext) else {return nil}
        dataForMAC.append(cipherText)
        let mac = dataForMAC.sha3(.keccak256)
        guard let calculatedMac = Data.fromHex(keystoreParams.crypto.mac),
            mac.constantTimeComparisonTo(calculatedMac) else {return nil}
        let decryptionKey = derivedKey[0...15]
        guard let IV = Data.fromHex(keystoreParams.crypto.cipherparams.iv) else {return nil}
        guard let aesCipher = try? AES(key: decryptionKey.bytes, blockMode: CTR(iv: IV.bytes), padding: .noPadding) else {return nil}
        guard let decryptedPK:Array<UInt8> = try? aesCipher.decrypt(cipherText.bytes) else { return nil }
        return Data(decryptedPK)
    }
    
    private func encryptData(passwordData: Data, salt: Data, length: Int, N: Int, R: Int, P: Int) -> Data? {
        guard let deriver = try? Scrypt(password: passwordData.bytes, salt: salt.bytes, dkLen: length, N: N, r: R, p: P) else {return nil}
        guard let result = try? deriver.calculate() else {return nil}
        return Data(result)
    }
    
    private func encryptDataToStorage(_ passwordData: Data, data: Data, dkLen: Int=32, N: Int = 1024, R: Int = 8, P: Int = 1) async throws -> KeystoreParamsV3 {
        let saltLen = 32;
        guard let saltData = Data.randomBytes(length: saltLen) else { throw KeystoreError.randomBytesErrror }
        guard let derivedKey = encryptData(passwordData: passwordData,
                                           salt: saltData,
                                           length: dkLen,
                                           N: N,
                                           R: R,
                                           P: P) else {throw KeystoreError.keyDerivationError}
        let last16bytes = Data(derivedKey[(derivedKey.count - 16)...(derivedKey.count-1)])
        let encryptionKey = Data(derivedKey[0...15])
        guard let IV = Data.randomBytes(length: 16) else { throw KeystoreError.randomBytesErrror }
        let aesCipher = try? AES(key: encryptionKey.bytes, blockMode: CTR(iv: IV.bytes), padding: .noPadding)
        guard let encryptedKey = try aesCipher?.encrypt(data.bytes) else { throw KeystoreError.aesError }
        let encryptedKeyData = Data(encryptedKey)
        var dataForMAC = Data()
        dataForMAC.append(last16bytes)
        dataForMAC.append(encryptedKeyData)
        let mac = dataForMAC.sha3(.keccak256)
        
        let kdfparams = KeystoreParamsV3.CryptoParamsV3.KdfParamsV3(salt: saltData.toHexString(), dklen: dkLen, n: N, p: P, r: R)
        let cipherparams = KeystoreParamsV3.CryptoParamsV3.CipherParamsV3(iv: IV.toHexString())
        let crypto = KeystoreParamsV3.CryptoParamsV3(ciphertext: encryptedKeyData.toHexString(), cipher: "aes-128-ctr", cipherparams: cipherparams, kdf: "scrypt", kdfparams: kdfparams, mac: mac.toHexString(), version: nil)
        return KeystoreParamsV3(crypto: crypto, id: UUID().uuidString.lowercased(), version: 3)
    }
}




fileprivate var hexPrefix = "0x"

extension String {
    
    public func stripHexPrefix() -> String {
        var hex = self
        if hex.hasPrefix(hexPrefix) {
            hex = String(hex.dropFirst(hexPrefix.count))
        }
        return hex
    }
    
    public func addHexPrefix() -> String {
        return hexPrefix.appending(self)
    }
    
    public func toHexString() -> String {
        guard let data = data(using: .utf8) else {
            return ""
        }
        return data.toHexString()
    }
}

extension Data {
    public func dataToHexString() -> String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    public static func fromHex(_ hex: String) -> Data? {
        let string = hex.lowercased().stripHexPrefix()
        let array = Array<UInt8>(hex: string)
        if (array.count == 0) {
            if (hex == "0x" || hex == "") {
                return Data()
            } else {
                return nil
            }
        }
        return Data(array)
    }
    
    public func constantTimeComparisonTo(_ other:Data?) -> Bool {
        guard let rhs = other else {return false}
        guard self.count == rhs.count else {return false}
        var difference = UInt8(0x00)
        for i in 0..<self.count { // compare full length
            difference |= self[i] ^ rhs[i] //constant time
        }
        return difference == UInt8(0x00)
    }
}
