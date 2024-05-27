//
//  AppleSignInService.swift
//  Cooplay
//
//  Created by Alexandr on 24.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import CryptoKit
import AuthenticationServices

protocol AppleAuthorizationServiceType {
    
    var currentNonce: String { get }
    func requestAuthorization() async throws -> ASAuthorizationAppleIDCredential
}

class AppleAuthorizationService: NSObject {
    
    var currentNonce = ""
    private var continuation : CheckedContinuation<ASAuthorizationAppleIDCredential, Error>?
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

extension AppleAuthorizationService: AppleAuthorizationServiceType {
    
    func requestAuthorization() async throws -> ASAuthorizationAppleIDCredential {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            currentNonce = randomNonceString()
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.email]
            request.nonce = sha256(currentNonce)

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
}

extension AppleAuthorizationService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if case let appleIDCredential as ASAuthorizationAppleIDCredential = authorization.credential {
            continuation?.resume(returning: appleIDCredential)
        } else {
            continuation?.resume(throwing: AuthorizationServiceError.unknownError)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
    }
    
}
