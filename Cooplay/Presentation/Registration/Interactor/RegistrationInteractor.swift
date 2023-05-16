//
//  RegistrationInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

enum RegistrationError: Error {
    
    case incorrectEmail(message: String)
    case incorrectConfirmPassword(message: String)
    case passwordSymbolsCountError
    case passwordBigSymbolsError
    case passwordNumericSymbolsError
    case multipleErrors(errors: [RegistrationError])
    case unhandled(error: Error)
}

extension RegistrationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .incorrectConfirmPassword(let message): return message
        case .incorrectEmail(let message): return message
        case .passwordSymbolsCountError: return nil
        case .passwordBigSymbolsError: return nil
        case .passwordNumericSymbolsError: return nil
        case .multipleErrors: return nil
        case .unhandled(let error):
            return error.localizedDescription
        }
    }
}

final class RegistrationInteractor {
    
    private enum Constant {
        
        static let minPasswordSymbolsCount = 8
        static let numericSymbols = "0123456789"
    }
    
    private let authorizationService: AuthorizationServiceType?
    
    init(authorizationService: AuthorizationServiceType?) {
        self.authorizationService = authorizationService
    }
}

// MARK: - RegistrationInteractorInput

extension RegistrationInteractor: RegistrationInteractorInput {
    
    func validatePassword(_ password: String) -> RegistrationError? {
        var errors = [RegistrationError]()
        if password.count < Constant.minPasswordSymbolsCount {
            errors.append(.passwordSymbolsCountError)
        }
        var hasNumeric = false
        var hasBigSymbol = false
        for character in password {
            if Constant.numericSymbols.contains(character) {
                hasNumeric = true
            }
            if character.isUppercase {
                hasBigSymbol = true
            }
        }
        if !hasNumeric {
            errors.append(.passwordNumericSymbolsError)
        }
        if !hasBigSymbol {
            errors.append(.passwordBigSymbolsError)
        }
        if errors.isEmpty {
            return nil
        } else {
            return .multipleErrors(errors: errors)
        }
    }
    
    func validatePasswordConfirmation(password: String?, confirmPassword: String?) -> RegistrationError? {
        if password == confirmPassword {
            return nil
        } else {
            return .incorrectConfirmPassword(
                message: R.string.localizable.registrationErrorPasswordConfirmWrong()
            )
        }
    }

    func validateEmail(
        _ email: String,
        completion: @escaping (Result<Void, RegistrationError>) -> Void) {
        guard email.isEmail else {
            completion(.failure(.incorrectEmail(
                message: R.string.localizable.registrationErrorEmailIncorret())
            ))
            return
        }
        authorizationService?.checkAccountExistence(email: email) { result in
            switch result {
            case .success(let isExist):
                if isExist {
                    completion(.failure(.incorrectEmail(
                        message: R.string.localizable.registrationErrorEmailAlreadyExist()))
                    )
                } else {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func register(
        email: String?,
        password: String?,
        completion: @escaping (Result<User, RegistrationError>) -> Void) {
        guard let email = email, let password = password else { return }
        authorizationService?.createAccaunt(email: email, password: password) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
