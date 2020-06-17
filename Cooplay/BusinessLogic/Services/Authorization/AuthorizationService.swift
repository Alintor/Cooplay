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
    case unhandled(error: Error)
}

extension AuthorizationServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
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
    
    init(firebaseAuth: Auth) {
        self.firebaseAuth = firebaseAuth
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
                state: nil,
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
            completion(.success(methods?.isEmpty != true))
        }
    }
    
    func logout() {
        try? firebaseAuth.signOut()
    }
}
