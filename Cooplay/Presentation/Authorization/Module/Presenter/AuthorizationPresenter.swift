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
                self?.router.clearNavigationStack()
                if let email = self?.email {
                    self?.view.setEmail(email)
                }
            }
            view.passwordRecoveryAction = { [weak self] in
            }
            view.registrationAction = { [weak self] in
                self?.router.openRegistration(with: self?.email)
            }
            view.nextAction = { [weak self] in
                self?.view.cleanErrorMessages()
                self?.tryLogin()
            }
            view.checkEmail = { [weak self] in
                guard let email = self?.email else { return }
                self?.view.showEmailChecking()
                self?.interactor.checkEmail(email) { [weak self] (result) in
                    guard let `self` = self else { return }
                    self.view.hideEmailChecking()
                    switch result {
                    case .success:
                        self.view.cleanErrorMessage(forField: .email(value: nil))
                        self.isEmailCorrect = true
                    case .failure(let error):
                        self.showError(error)
                    }
                    self.view.setNextButtonEnabled(self.isReady)
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
                self.view.setNextButtonEnabled(self.isReady)
            }
        }
    }
    var interactor: AuthorizationInteractorInput!
    var router: AuthorizationRouterInput!
    
    // MARK: - Pricate
    
    private var email: String?
    private var password: String?
    private var isEmailCorrect = false
    private var isReady: Bool {
        return interactor.isReady(email: self.email, password: self.password) && isEmailCorrect
    }
    
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
            isEmailCorrect = false
        case .incorrectPassword(let message):
            view.showErrorMessage(message, forField: .password(value: nil))
        case .multipleErrors(let errors):
            errors.forEach { self.showError($0) }
        case .unhandled(let error):
            print(error.localizedDescription)
            // TODO:
        }
    }
}

// MARK: - AuthorizationModuleInput

extension AuthorizationPresenter: AuthorizationModuleInput {

    func configure(with email: String?) {
        self.email = email
    }
}
