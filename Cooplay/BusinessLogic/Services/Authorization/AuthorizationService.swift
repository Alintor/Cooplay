//
//  AuthorizationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

enum AuthorizationServiceError: Error {
    
    case unknownError
    case authorizationError(error: Error)
    case unhandled(error: Error)
}

extension AuthorizationServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .authorizationError(let error): return error.localizedDescription
        case .unknownError: return nil // TODO:
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol AuthorizationServiceType {
    
    var isLoggedIn: Bool { get }
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, AuthorizationServiceError>) -> Void
    )
    func createAccaunt(
        email: String,
        password: String,
        completion: @escaping (Result<User, AuthorizationServiceError>) -> Void
    )
    func checkAccountExistence(
        email: String,
        completion: @escaping (Result<Bool, AuthorizationServiceError>) -> Void
    )
    func logout()
}


final class AuthorizationService {
    
    private let firebaseAuth: Auth
    private let defaultsStorages: DefaultsStorageType?
    
    init(firebaseAuth: Auth, defaultsStorages: DefaultsStorageType?) {
        self.firebaseAuth = firebaseAuth
        self.defaultsStorages = defaultsStorages
    }
}

extension AuthorizationService: AuthorizationServiceType {
    
    var isLoggedIn: Bool {
        return firebaseAuth.currentUser != nil
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, AuthorizationServiceError>) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(.authorizationError(error: error)))
            }
            if result != nil {
                completion(.success(()))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    func createAccaunt(
        email: String,
        password: String,
        completion: @escaping (Result<User, AuthorizationServiceError>) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            }
            guard let result = result else {
                completion(.failure(.unknownError))
                return
            }
            // TODO: Add compact init
            let user = User(
                id: result.user.uid,
                name: nil,
                avatarPath: nil,
                state: .unknown,
                lateness: nil,
                isOwner: nil
            )
            completion(.success(user))
        }
    }
    
    func checkAccountExistence(
        email: String,
        completion: @escaping (Result<Bool, AuthorizationServiceError>) -> Void) {
        firebaseAuth.fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            }
            if let methods = methods {
                completion(.success(!methods.isEmpty))
            } else {
                completion(.success(false))
            }
        }
    }
    
    func logout() {
        try? firebaseAuth.signOut()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        defaultsStorages?.clear()
    }
}
