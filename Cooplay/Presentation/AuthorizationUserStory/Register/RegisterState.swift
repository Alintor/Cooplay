//
//  RegisterState.swift
//  Cooplay
//
//  Created by Alexandr on 12.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

class RegisterState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    @Published var email: String
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var emailError: TextFieldView.ErrorType?
    @Published var passwordError: TextFieldView.ErrorType? = .passwordValidation(
        types: [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
    )
    @Published var confirmPasswordError: TextFieldView.ErrorType?
    @Published var isEmailCorrect: Bool = false
    @Published var showEmailChecking: Bool = false
    @Published var showProgress: Bool = false
    var isReady: Bool {
        isEmailCorrect && passwordError?.isValid == true && password == confirmPassword
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, email: String = "") {
        self.store = store
        self.authorizationService = authorizationService
        self.email = email
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleEmailChecking(isExist: Bool) {
        showEmailChecking = false
        isEmailCorrect = !isExist
        emailError = .text(message: isExist ? Localizable.registrationErrorEmailAlreadyExist() : nil)
    }
    
    @MainActor private func handleRegisterResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            store.dispatch(.successAuthentication)
        } else {
            store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
        }
    }
    
    // MARK: - Methods
    
    func checkEmail() {
        guard email.isEmail else {
            emailError = nil
            return
        }
        
        showEmailChecking = true
        Task {
            do {
                let isExist = try await authorizationService.checkAccountExistence(email: email)
                await handleEmailChecking(isExist: isExist)
            } catch {
                store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
            }
        }
    }
    
    func checkPassword() {
        passwordError = .passwordValidation(types: Validation.password(password))
    }
    
    func checkConfirmPassword() {
        guard !confirmPassword.isEmpty else {
            confirmPasswordError = nil
            return
        }
        
        confirmPasswordError = .text(
            message: password != confirmPassword 
                ? Localizable.registrationErrorPasswordConfirmWrong()
                : nil
        )
    }
    
    func tryRegister() {
        showProgress = true
        Task {
            do {
                try await authorizationService.createAccount(email: email, password: password)
                await handleRegisterResult(isSuccess: true)
            } catch {
                await handleRegisterResult(isSuccess: false)
            }
        }
    }
    
}
