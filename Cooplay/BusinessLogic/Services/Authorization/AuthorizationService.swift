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
    case unhandled(error: Error)
}

extension AuthorizationServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .authorizationError(let error): return error.localizedDescription
        case .unknownError: return Localizable.errorsUnknown()
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol AuthorizationServiceType {
    
    var isLoggedIn: Bool { get }
    func login(email: String, password: String) async throws
    func createAccount(email: String, password: String) async throws
    func checkAccountExistence(email: String) async throws -> Bool
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
}
