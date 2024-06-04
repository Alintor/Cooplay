//
//  AuthorizationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth

enum ReauthProvider {
    
    case password(_ password: String)
    case apple(creds: ASAuthorizationAppleIDCredential, nonce: String)
    case google
}

enum AuthorizationServiceError: Error {
    
    case unknownError
    case authorizationError(error: Error)
    case wrongPassword
    case changePasswordError
    case notHaveRestEmail
    case needRelogin
    case emailAlreadyInUse
    case credentialAlreadyInUse
    case unhandled(error: Error)
}

extension AuthorizationServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .authorizationError(let error): return error.localizedDescription
        case .unknownError: return Localizable.errorsUnknown()
        case .wrongPassword: return Localizable.errorsAuthorizationServiceWrongPassword()
        case .changePasswordError: return Localizable.errorsAuthorizationServiceChangePassword()
        case .notHaveRestEmail: return nil
        case .needRelogin: return nil
        case .emailAlreadyInUse: return Localizable.errorsAuthorizationServiceEmailAlreadyInUse()
        case .credentialAlreadyInUse: return Localizable.errorsAuthorizationServiceCredentialAlreadyInUse()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol AuthorizationServiceType {
    
    var isLoggedIn: Bool { get }
    var userEmail: String? { get }
    func login(email: String, password: String) async throws
    func createAccount(email: String, password: String) async throws
    func signInWithGoogle() async throws
    func signInWithApple(creds: ASAuthorizationAppleIDCredential, nonce: String) async throws
    func checkAccountExistence(email: String) async throws -> Bool
    func changePassword(currentPassword: String, newPassword: String) async throws
    func sendResetPasswordEmail(_ email: String) async throws
    func fetchResetEmail(oobCode: String) async throws -> String
    func resetPassword(newPassword: String, oobCode: String) async throws
    func getUserProviders() -> [AuthProvider]
    func linkGoogleProvider() async throws
    func linkAppleProvider(creds: ASAuthorizationAppleIDCredential, nonce: String) async throws
    func addPassword(_ password: String, email: String, provider: ReauthProvider?) async throws
    func unlinkProvider(_ provider: AuthProvider) async throws
    func getEmailForProvider(_ provider: AuthProvider) -> String?
    func logout()
    func deleteAccount(provider: ReauthProvider) async throws
}


final class AuthorizationService {
    
    private let firebaseAuth: Auth
    private let firestore: Firestore
    private let defaultsStorages: DefaultsStorageType?
    
    init(firebaseAuth: Auth, firestore: Firestore, defaultsStorages: DefaultsStorageType?) {
        firebaseAuth.useAppLanguage()
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
        self.defaultsStorages = defaultsStorages
    }
    
    // MARK: - Private Methods
    
    private func getGoogleCredential() async throws -> AuthCredential {
        guard
            let clientId = FirebaseApp.app()?.options.clientID,
            let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = await windowScene.windows.first?.rootViewController
        else { throw AuthorizationServiceError.unknownError }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthorizationServiceError.unknownError
        }
        return GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
    }
    
    private func reauthenticate(currentPassword: String) async throws -> FirebaseAuth.User {
        guard
            let currentUser = firebaseAuth.currentUser,
            let email = currentUser.email
        else {
            throw AuthorizationServiceError.unknownError
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        do {
            let result = try await currentUser.reauthenticate(with: credential)
            return result.user
        } catch {
            throw AuthorizationServiceError.wrongPassword
        }
    }
    
    private func reauthenticateWithProvider(_ provider: ReauthProvider) async throws -> FirebaseAuth.User {
        guard let currentUser = firebaseAuth.currentUser else {
            throw AuthorizationServiceError.unknownError
        }
        
        switch provider {
        case .password(let password):
            return try await reauthenticate(currentPassword: password)
        case .apple(let creds, let nonce):
            guard
                let appleIDToken = creds.identityToken,
                let idTokenString = String(data: appleIDToken, encoding: .utf8)
            else {
                throw AuthorizationServiceError.unknownError
            }
            
            let appleCreds = OAuthProvider.credential(withProviderID: AuthProvider.apple.rawValue, idToken: idTokenString, rawNonce: nonce)
            let result = try await currentUser.reauthenticate(with: appleCreds)
            return result.user
        case .google:
            let googleCreds = try await getGoogleCredential()
            let result = try await currentUser.reauthenticate(with: googleCreds)
            return result.user
        }
    }
    
    private func handleLinkError(_ error: Error) -> AuthorizationServiceError {
        if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
            return .emailAlreadyInUse
        } else if (error as NSError).code == AuthErrorCode.credentialAlreadyInUse.rawValue {
            return .credentialAlreadyInUse
        } else {
            return .unhandled(error: error)
        }
    }
}

extension AuthorizationService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .logout:
            logout()
        default: break
        }
    }
    
}

extension AuthorizationService: AuthorizationServiceType {
    
    var isLoggedIn: Bool {
        return firebaseAuth.currentUser != nil
    }
    
    var userEmail: String? {
        guard
            let currentUser = firebaseAuth.currentUser,
            let email = currentUser.email
        else {
            return nil
        }
        
        return email
    }
    
    func login(email: String, password: String) async throws {
        try await firebaseAuth.signIn(withEmail: email, password: password)
    }
    
    func createAccount(email: String, password: String) async throws {
        let result = try await firebaseAuth.createUser(withEmail: email, password: password)
        let data = [
            "id": result.user.uid,
            "name": "",
            "notificationsInfo": NotificationsInfo().dictionary!
        ] as [String : Any]
        try await Firestore.firestore().collection("Users").document(result.user.uid).setData(data)
    }
    
    func signInWithGoogle() async throws {
        let credential = try await getGoogleCredential()
        let authResult = try await firebaseAuth.signIn(with: credential)
        let user = try? await Firestore.firestore().collection("Users").document(authResult.user.uid).getDocument()
        if user?.data() == nil {
            let data = [
                "id": authResult.user.uid,
                "name": "",
                "notificationsInfo": NotificationsInfo().dictionary!
            ] as [String : Any]
            try await Firestore.firestore().collection("Users").document(authResult.user.uid).setData(data)
        }
    }
    
    func signInWithApple(creds: ASAuthorizationAppleIDCredential, nonce: String) async throws {
        guard 
            let appleIDToken = creds.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            throw AuthorizationServiceError.unknownError
        }
        
        let credential = OAuthProvider.credential(withProviderID: AuthProvider.apple.rawValue, idToken: idTokenString, rawNonce: nonce)
        let authResult = try await firebaseAuth.signIn(with: credential)
        let user = try? await Firestore.firestore().collection("Users").document(authResult.user.uid).getDocument()
        if user?.data() == nil {
            let data = [
                "id": authResult.user.uid,
                "name": "",
                "notificationsInfo": NotificationsInfo().dictionary!
            ] as [String : Any]
            try await Firestore.firestore().collection("Users").document(authResult.user.uid).setData(data)
        }
    }
    
    func checkAccountExistence(email: String) async throws -> Bool {
        let methods = try await firebaseAuth.fetchSignInMethods(forEmail: email)
        return !methods.isEmpty
    }
    
    func logout() {
        try? firebaseAuth.signOut()
        defaultsStorages?.clear()
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        let currentUser = try await reauthenticate(currentPassword: currentPassword)
        try await currentUser.updatePassword(to: newPassword)
    }
    
    func sendResetPasswordEmail(_ email: String) async throws {
        firebaseAuth.useAppLanguage()
        try await firebaseAuth.sendPasswordReset(withEmail: email)
    }
    
    func fetchResetEmail(oobCode: String) async throws -> String {
        let codeInfo = try await firebaseAuth.checkActionCode(oobCode)
        if let email = codeInfo.email {
            return email
        } else {
            throw AuthorizationServiceError.notHaveRestEmail
        }
    }
    
    func resetPassword(newPassword: String, oobCode: String) async throws {
        try await firebaseAuth.confirmPasswordReset(withCode: oobCode, newPassword: newPassword)
    }
    
    func getUserProviders() -> [AuthProvider] {
        guard let providers = firebaseAuth.currentUser?.providerData else { return [] }
        
        for provider in providers {
            print(provider.providerID)
        }
        return providers.compactMap { AuthProvider(rawValue: $0.providerID) }
    }
    
    func getEmailForProvider(_ provider: AuthProvider) -> String? {
        guard let providers = firebaseAuth.currentUser?.providerData else { return nil }
        
        return providers.first(where: { $0.providerID == provider.rawValue})?.email
    }
    
    func linkGoogleProvider() async throws {
        guard
            let user = firebaseAuth.currentUser,
            let clientId = FirebaseApp.app()?.options.clientID,
            let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = await windowScene.windows.first?.rootViewController
        else { throw UserServiceError.unknownError }
        
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthorizationServiceError.unknownError
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: result.user.accessToken.tokenString)
        do {
            try await user.link(with: credential)
        } catch {
            throw handleLinkError(error)
        }
    }
    
    func linkAppleProvider(creds: ASAuthorizationAppleIDCredential, nonce: String) async throws {
        guard
            let user = firebaseAuth.currentUser,
            let appleIDToken = creds.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8)
        else {
            throw AuthorizationServiceError.unknownError
        }
        
        let credential = OAuthProvider.credential(withProviderID: AuthProvider.apple.rawValue, idToken: idTokenString, rawNonce: nonce)
        do {
            try await user.link(with: credential)
        } catch {
            throw handleLinkError(error)
        }
    }
    
    func addPassword(_ password: String, email: String, provider: ReauthProvider?) async throws {
        guard var currentUser = firebaseAuth.currentUser else {
            throw AuthorizationServiceError.unknownError
        }
        if let provider {
            _ = try await reauthenticateWithProvider(provider)
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await currentUser.link(with: credential)
        } catch {
            if (error as NSError).code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw AuthorizationServiceError.needRelogin
            } else {
                throw error
            }
        }
    }
    
    func unlinkProvider(_ provider: AuthProvider) async throws {
        guard let user = firebaseAuth.currentUser else { throw UserServiceError.unknownError }
        
        try await user.unlink(fromProvider: provider.rawValue)
    }
    
    func deleteAccount(provider: ReauthProvider) async throws {
        let user = try await reauthenticateWithProvider(provider)
        try await firestore.collection("Users").document(user.uid).updateData(["isDeleted": true])
        try await user.delete()
    }
    
}
