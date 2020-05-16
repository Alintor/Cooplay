//
//  AuthorizationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

final class AuthorizationPresenter {

    // MARK: - Properties

    weak var view: AuthorizationViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
            view.passwordRecoveryAction = { [weak self] in
            }
            view.registrationAction = { [weak self] in
            }
            view.nextAction = { [weak self] in
                self?.view.cleanErrorMessages()
                self?.tryLogin()
            }
            view.checkEmail = { [weak self] in
                guard let email = self?.email else { return }
                self?.view.showEmailChecking()
                self?.interactor.checkEmail(email) { [weak self] (result) in
                    self?.view.hideEmailChecking()
                    switch result {
                    case .success:
                        self?.view.cleanErrorMessage(forField: .email(value: nil))
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
            view.fieldValueChanged = { [weak self] field in
                guard let `self` = self else { return }
                switch field {
                case .email(let value):
                    self.email = value
                case .password(let value):
                    self.password = value
                }
                self.view.setNextButtonEnabled(self.interactor.isReady(
                    email: self.email,
                    password: self.password
                ))
            }
        }
    }
    var interactor: AuthorizationInteractorInput!
    var router: AuthorizationRouterInput!
    
    // MARK: - Pricate
    
    private var email: String?
    private var password: String?
    
    private func tryLogin() {
        view.showProgress(indicatorType: .arrows)
        interactor.tryLogin(email: self.email, password: self.password) { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success:
                self.router.openEventList()
            case .failure(let error):
                self.showError(error)
            }
        }
    }
    
    private func showError(_ error: AuthorizationError) {
        switch error {
        case .incorrectEmail(let message):
            view.showErrorMessage(message, forField: .email(value: nil))
        case .incorrectPassword(let message):
            view.showErrorMessage(message, forField: .password(value: nil))
        case .multipleErrors(let errors):
            errors.forEach { self.showError($0) }
        case .unhandled(let error):
            break
            // TODO:
        }
    }
}

// MARK: - AuthorizationModuleInput

extension AuthorizationPresenter: AuthorizationModuleInput {

}
