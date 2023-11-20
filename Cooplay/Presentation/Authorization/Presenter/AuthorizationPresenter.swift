//
//  AuthorizationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

final class AuthorizationPresenter {

    // MARK: - Properties

    private weak var view: AuthorizationViewInput!
    private let interactor: AuthorizationInteractorInput
    private let router: AuthorizationRouterInput
    private let store: Store
    
    // MARK: - Init
    
    init(
        view: AuthorizationViewInput,
        interactor: AuthorizationInteractorInput,
        router: AuthorizationRouterInput,
        store: Store
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.store = store
    }
    
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
                store.send(.successAuthentication)
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

// MARK: - AuthorizationViewOutput

extension AuthorizationPresenter: AuthorizationViewOutput {
    
    func didLoad() {
        view.setupInitialState()
        router.clearNavigationStack()
        if let email = self.email {
            view.setEmail(email)
        }
    }
    
    func didChangeField(_ field: AuthorizationField) {
        switch field {
        case .email(let value):
            email = value
        case .password(let value):
            password = value
        }
        view.setNextButtonEnabled(isReady)
    }
    
    func didTapNext() {
        view.cleanErrorMessages()
        tryLogin()
    }
    
    func checkEmail() {
        guard let email = self.email else { return }
        
        view.showEmailChecking()
        interactor.checkEmail(email) { [weak self] (result) in
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
    
    func didTapPasswordRecovery() {
        
    }
    
    func didTapRegistration() {
        router.openRegistration(with: self.email)
    }

}

// MARK: - AuthorizationModuleInput

extension AuthorizationPresenter: AuthorizationModuleInput {

    func configure(with email: String?) {
        self.email = email
    }
}
