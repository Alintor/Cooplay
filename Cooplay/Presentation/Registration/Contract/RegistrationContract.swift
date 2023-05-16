//
//  RegistrationContract.swift
//  Cooplay
//
//  Created by Alexandr on 16.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol RegistrationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    func setupInitialState()
    func showErrorMessage(_ message: String, forField field: RegistrationField)
    func cleanErrorMessage(forField field: RegistrationField)
    func cleanErrorMessages()
    func setNextButtonEnabled(_ isEnabled: Bool)
    func showEmailChecking()
    func hideEmailChecking()
    func setSymbolsCountErrorState(_ state: PasswordValidationState)
    func setBigSymbolsErrorState(_ state: PasswordValidationState)
    func setNumericSymbolErrorState(_ state: PasswordValidationState)
    func setState(_ state: PasswordValidationState, forField field: RegistrationField)
    func setEmail(_ text: String)
}

protocol RegistrationViewOutput: AnyObject {
    
    func didLoad()
    func didChangeField(_ field: RegistrationField)
    func didTapNext()
    func didTapLogin()
    func checkEmail()
}

// MARK: - Interactor

protocol RegistrationInteractorInput: AnyObject {

    func validatePassword(_ password: String) -> RegistrationError?
    func validatePasswordConfirmation(
        password: String?,
        confirmPassword: String?
    ) -> RegistrationError?
    func validateEmail(
        _ email: String,
        completion: @escaping (Result<Void, RegistrationError>) -> Void
    )
    func register(
        email: String?,
        password: String?,
        completion: @escaping (Result<User, RegistrationError>) -> Void
    )
}

// MARK: - Router

protocol RegistrationRouterInput: AnyObject {

    func openAuthorization(with email: String?)
    func clearNavigationStack()
    func openPersonalisation(with user: User)
}

// MARK: - Module Input

protocol RegistrationModuleInput: AnyObject {

    func configure(with email: String?)
}
