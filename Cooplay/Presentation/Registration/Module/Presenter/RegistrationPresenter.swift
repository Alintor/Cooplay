//
//  RegistrationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

final class RegistrationPresenter {

    // MARK: - Properties

    weak var view: RegistrationViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.router.clearNavigationStack()
                if let email = self?.email {
                    self?.view.setEmail(email)
                }
            }
            view.loginAction = { [weak self] in
                self?.router.openAuthorization(with: self?.email)
            }
            view.nextAction = { [weak self] in
                self?.view.cleanErrorMessages()
                self?.register()
            }
            view.checkEmail = { [weak self] in
                guard let email = self?.email else { return }
                self?.view.cleanErrorMessage(forField: .email(value: nil))
                self?.view.showEmailChecking()
                self?.interactor.validateEmail(email) { [weak self] (result) in
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
            view.fieldValueChanged = { [weak self] field in
                guard let `self` = self else { return }
                switch field {
                case .email(let value):
                    self.email = value
                case .password(let value):
                    self.password = value
                    guard let password = value, !password.isEmpty else {
                        self.view.setSymbolsCountErrorState(.clear)
                        self.view.setBigSymbolsErrorState(.clear)
                        self.view.setNumericSymbolErrorState(.clear)
                        self.view.setState(.clear, forField: .password(value: nil))
                        return
                    }
                    self.view.setSymbolsCountErrorState(.correct)
                    self.view.setBigSymbolsErrorState(.correct)
                    self.view.setNumericSymbolErrorState(.correct)
                    if let error = self.interactor.validatePassword(password) {
                        self.handleError(error)
                        self.view.setState(.error, forField: .password(value: nil))
                    } else {
                        self.isPasswordCorrect = true
                        self.view.setState(.correct, forField: .password(value: nil))
                    }
                case .confirmPassword(let value):
                    if let error = self.interactor.validatePasswordConfirmation(password: self.password, confirmPassword: value) {
                        self.handleError(error)
                    } else {
                        self.isConfirmPasswordCorrect = true
                        self.view.cleanErrorMessage(forField: .confirmPassword(value: nil))
                        self.view.setState(.correct, forField: .confirmPassword(value: nil))
                    }
                }
                self.view.setNextButtonEnabled(self.isReady)
            }
        }
    }
    var interactor: RegistrationInteractorInput!
    var router: RegistrationRouterInput!
    
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
                break
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

// MARK: - RegistrationModuleInput

extension RegistrationPresenter: RegistrationModuleInput {

    func configure(with email: String?) {
        self.email = email
    }
}
