//
//  RegistrationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

final class RegistrationPresenter {

    // MARK: - Properties

    private weak var view: RegistrationViewInput!
    private let interactor: RegistrationInteractorInput
    private let router: RegistrationRouterInput
    private let store: Store
    
    // MARK: - Init
    
    init(
        view: RegistrationViewInput,
        interactor: RegistrationInteractorInput,
        router: RegistrationRouterInput,
        store: Store
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.store = store
    }
    
    // MARK: - Private
    private var email: String?
    private var password: String?
    private var isEmailCorrect = false
    private var isPasswordCorrect = false
    private var isConfirmPasswordCorrect = false
    private var isReady: Bool {
        return isEmailCorrect && isPasswordCorrect && isConfirmPasswordCorrect
    }
    
    private func register() {
        view.showProgress(indicatorType: .arrows)
        interactor.register(email: email, password: password) { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success:
                store.send(.successAuthentication)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: RegistrationError) {
        switch error {
        case .incorrectEmail(let message):
            view.showErrorMessage(message, forField: .email(value: nil))
            isEmailCorrect = false
        case .incorrectConfirmPassword(let message):
            view.showErrorMessage(message, forField: .confirmPassword(value: nil))
            isConfirmPasswordCorrect = false
        case .passwordSymbolsCountError:
            view.setSymbolsCountErrorState(.error)
            isPasswordCorrect = false
        case .passwordBigSymbolsError:
            view.setBigSymbolsErrorState(.error)
            isPasswordCorrect = false
        case .passwordNumericSymbolsError:
            view.setNumericSymbolErrorState(.error)
            isPasswordCorrect = false
        case .multipleErrors(let errors):
            errors.forEach { self.handleError($0) }
        case .unhandled(let error):
            break
            // TODO:
        }
    }
}

// MARK: - RegistrationViewOutput

extension RegistrationPresenter: RegistrationViewOutput {
    
    func didLoad() {
        view.setupInitialState()
        router.clearNavigationStack()
        if let email = self.email {
            view.setEmail(email)
        }
    }
    
    func didChangeField(_ field: RegistrationField) {
        switch field {
        case .email(let value):
            email = value
        case .password(let value):
            password = value
            guard let password = value, !password.isEmpty else {
                view.setSymbolsCountErrorState(.clear)
                view.setBigSymbolsErrorState(.clear)
                view.setNumericSymbolErrorState(.clear)
                view.setState(.clear, forField: .password(value: nil))
                return
            }
            view.setSymbolsCountErrorState(.correct)
            view.setBigSymbolsErrorState(.correct)
            view.setNumericSymbolErrorState(.correct)
            if let error = interactor.validatePassword(password) {
                handleError(error)
                view.setState(.error, forField: .password(value: nil))
            } else {
                isPasswordCorrect = true
                view.setState(.correct, forField: .password(value: nil))
            }
        case .confirmPassword(let value):
            if let error = interactor.validatePasswordConfirmation(password: password, confirmPassword: value) {
                handleError(error)
            } else {
                isConfirmPasswordCorrect = true
                view.cleanErrorMessage(forField: .confirmPassword(value: nil))
                view.setState(.correct, forField: .confirmPassword(value: nil))
            }
        }
        view.setNextButtonEnabled(isReady)
    }
    
    func didTapNext() {
        view.cleanErrorMessages()
        register()
    }
    
    func didTapLogin() {
        router.openAuthorization(with: email)
    }
    
    func checkEmail() {
        guard let email = self.email else { return }
        
        view.cleanErrorMessage(forField: .email(value: nil))
        view.showEmailChecking()
        interactor.validateEmail(email) { [weak self] (result) in
            guard let `self` = self else { return }
            
            self.view.hideEmailChecking()
            switch result {
            case .success:
                self.isEmailCorrect = true
                self.view.setState(.correct, forField: .email(value: nil))
            case .failure(let error):
                self.handleError(error)
            }
            self.view.setNextButtonEnabled(self.isReady)
        }
    }
    

}

// MARK: - RegistrationModuleInput

extension RegistrationPresenter: RegistrationModuleInput {

    func configure(with email: String?) {
        self.email = email
    }
}
