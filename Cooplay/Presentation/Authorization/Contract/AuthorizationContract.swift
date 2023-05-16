//
//  AuthorizationContract.swift
//  Cooplay
//
//  Created by Alexandr on 16.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol AuthorizationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    func setupInitialState()
    func showErrorMessage(_ message: String, forField field: AuthorizationField)
    func cleanErrorMessage(forField field: AuthorizationField)
    func cleanErrorMessages()
    func setNextButtonEnabled(_ isEnabled: Bool)
    func showEmailChecking()
    func hideEmailChecking()
    func setEmail(_ text: String)
}

protocol AuthorizationViewOutput: AnyObject {
    
    func didLoad()
    func didChangeField(_ field: AuthorizationField)
    func didTapNext()
    func checkEmail()
    func didTapPasswordRecovery()
    func didTapRegistration()
    
}

// MARK: - Interactor

protocol AuthorizationInteractorInput: AnyObject {

    func isReady(email: String?, password: String?) -> Bool
    func tryLogin(
        email: String?,
        password: String?,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void
    )
    func checkEmail(
        _ email: String,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void
    )
}

// MARK: - Router

protocol AuthorizationRouterInput: StartRoutable {

    func openRegistration(with email: String?)
    func clearNavigationStack()
}

// MARK: - Module Input

protocol AuthorizationModuleInput: AnyObject {

    func configure(with email: String?)
}
