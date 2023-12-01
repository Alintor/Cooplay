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
    
    static func fromServiceError(_ error: AuthorizationServiceError) -> AuthorizationError {
        switch error {
        case .authorizationError:
            return .incorrectPassword(
                message: R.string.localizable.authorizationErrorPasswordWrong())
        default:
            return .unhandled(error: error)
        }
    }
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
    
    private let authorizationService: AuthorizationServiceType?
    
    init(authorizationService: AuthorizationServiceType?) {
        self.authorizationService = authorizationService
    }

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
        guard let email = email, let password = password else { return }
        authorizationService?.login(email: email, password: password) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.fromServiceError(error)))
            }
        }
    }
    
    func checkEmail(
        _ email: String,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void) {
        guard email.isEmail else {
            completion(.failure(.incorrectEmail(
                message: R.string.localizable.authorizationErrorEmailIncorrect())
            ))
            return
        }
        authorizationService?.checkAccountExistence(email: email) { result in
            switch result {
            case .success(let isExist):
                if isExist {
                    completion(.success(()))
                } else {
                    completion(.failure(.incorrectEmail(
                        message: R.string.localizable.authorizationErrorEmailNotExist()))
                    )
                }
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
