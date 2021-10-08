//
//  BiometricsAuthentication.swift
//  Wallet
//
//  Created by Ronald Mannak on 10/6/21.
//

import Foundation
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
    
    var description: String? {
        switch self {
        case .none: return nil
        case .touchID: return "touchID"
        case .faceID: return "faceID"
        }
    }
}

// This class can be used to shield certain parts of the app, but shouldn't be used for the private key. Instead, for private keys, use the KeychainPasswordItem class.
class BiometricIDAuth {
    
    let context = LAContext()
    
    /// Fetches available biometric authentication options
    /// Note: **do not store the result of this method as the status might change. Instead, call this method when needed**
    /// - Returns: Available biometric authentication type
    func biometricType() -> BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
            switch context.biometryType {
        case .none:
          return .none
        case .touchID:
          return .touchID
        case .faceID:
          return .faceID
        @unknown default:
            return .none
        }
    }

    func canEvaluatePolicy(allowBackupMethods: Bool = false) -> Bool {
        let policy: LAPolicy = allowBackupMethods == true ? .deviceOwnerAuthentication : .deviceOwnerAuthenticationWithBiometrics
        return context.canEvaluatePolicy(policy, error: nil)
    }

    
    /// Presents FaceID or TouchID interface and requires user to authticate
    ///
    /// Example:
    ///
    ///     guard biometricIDAuth.canEvaluatePolicy() else { return }
    ///     do {
    ///         if try await biometricIDAuth.authenticateUser() == true {
    ///             // User is authenticated
    ///         }
    ///     } catch {
    ///         // Handle error
    ///     }
    ///
    /// Possible LAErrors:
    ///
    ///     - LAError.authenticationFailed (There was a problem verifying the user's identity)
    ///     - LAError.userCancel (User cancelled the authentication)
    ///     - LAError.userFallback (User requested to enter password or PIN)
    ///     - LAError.biometryNotAvailable (Face ID/Touch ID is not available)
    ///     - LAError.biometryNotEnrolled (Face ID/Touch ID is not set up)
    ///     - LAError.biometryLockout (Face ID/Touch ID is locked)
    /// - Throws: LAError
    ///
    /// - Returns: True if user has successfully authenticated
    func authenticateUser(authReason: String? = nil) async throws -> Bool {
        
        guard canEvaluatePolicy() else { throw LAError(.biometryNotAvailable) }
        
        let reason = authReason ?? "\(biometricType().description ?? "") is required to access your private keys"
        
        guard try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) == true else {
           return false
        }
        
        return true
    }
}
