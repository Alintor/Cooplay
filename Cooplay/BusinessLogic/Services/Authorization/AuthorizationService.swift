//
//  AuthorizationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase

enum AuthorizationServiceError: Error {
    
    case unknownError
    case authorizationError(error: Error)
    case wrongPassword
    case changePasswordError
    case unhandled(error: Error)
}

extension AuthorizationServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .authorizationError(let error): return error.localizedDescription
        case .unknownError: return Localizable.errorsUnknown()
        case .wrongPassword: return Localizable.errorsAuthorizationServiceWrongPassword()
        case .changePasswordError: return Localizable.errorsAuthorizationServiceChangePassword()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol AuthorizationServiceType {
    
    var isLoggedIn: Bool { get }
    func login(email: String, password: String) async throws
    func createAccount(email: String, password: String) async throws
    func checkAccountExistence(email: String) async throws -> Bool
    func changePassword(currentPassword: String, newPassword: String) async throws
    func sendResetPasswordEmail(_ email: String) async throws
    func logout()
}


final class AuthorizationService {
    
    private let firebaseAuth: Auth
    private let defaultsStorages: DefaultsStorageType?
    
    init(firebaseAuth: Auth, defaultsStorages: DefaultsStorageType?) {
        firebaseAuth.useAppLanguage()
        self.firebaseAuth = firebaseAuth
        self.defaultsStorages = defaultsStorages
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
    
    func login(email: String, password: String) async throws {
        try await firebaseAuth.signIn(withEmail: email, password: password)
    }
    
    func createAccount(email: String, password: String) async throws {
        let result = try await firebaseAuth.createUser(withEmail: email, password: password)
        let data = [
            "id": result.user.uid,
            "name": "",
            "needStatusChangeNotifications": true,
            "needReactionsForMeNotifications": true,
            "needReactionsAllNotifications": true
        ] as [String : Any]
        try await Firestore.firestore().collection("Users").document(result.user.uid).setData(data)
    }
    
    func checkAccountExistence(email: String) async throws -> Bool {
        let methods = try await firebaseAuth.fetchSignInMethods(forEmail: email)
        return !methods.isEmpty
    }
    
    func logout() {
        try? firebaseAuth.signOut()
        defaultsStorages?.clear()
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
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        let currentUser = try await reauthenticate(currentPassword: currentPassword)
        try await currentUser.updatePassword(to: newPassword)
    }
    
    func sendResetPasswordEmail(_ email: String) async throws {
        firebaseAuth.useAppLanguage()
        try await firebaseAuth.sendPasswordReset(withEmail: email)
    }
    
}
