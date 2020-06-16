//
//  AuthorizationInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

enum AuthorizationError: Error {
    
    case incorrectEmail(message: String)
    case incorrectPassword(message: String)
    case multipleErrors(errors: [AuthorizationError])
    case unhandled(error: Error)
}

extension AuthorizationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .incorrectPassword(let message): return message
        case .incorrectEmail(let message): return message
        case .multipleErrors: return nil
        case .unhandled(let error):
            return error.localizedDescription
        }
    }
}

final class AuthorizationInteractor {

}

// MARK: - AuthorizationInteractorInput

extension AuthorizationInteractor: AuthorizationInteractorInput {

    func isReady(email: String?, password: String?) -> Bool {
        guard
            let email = email, !email.isEmpty,
            let password = password, !password.isEmpty
        else { return false }
        return true
    }
    
    func tryLogin(
        email: String?,
        password: String?,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            //completion(.failure(.incorrectPassword(message: R.string.localizable.authorizationErrorPasswordWrong())))
            completion(.success(()))
        }
    }
    
    func checkEmail(
        _ email: String,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void) {
        guard email.isEmail else {
            completion(.failure(.incorrectEmail(
                message: R.string.localizable.authorizationErrorEmailIncorret())
            ))
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion(.failure(.incorrectEmail(message: R.string.localizable.authorizationErrorEmailNotExist())))
            completion(.success(()))
        }
    }
}
