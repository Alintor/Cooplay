//
//  AuthorizationState.swift
//  Cooplay
//
//  Created by Alexandr on 29.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

final class LoginState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    @Published var email: String
    @Published var password: String = ""
    @Published var emailError: TextFieldView.ErrorType?
    @Published var passwordError: TextFieldView.ErrorType?
    @Published var showProgress: Bool = false
    var isReady: Bool {
        email.isEmail && !password.isEmpty
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, email: String = "") {
        self.store = store
        self.authorizationService = authorizationService
        self.email = email
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleLoginResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            store.dispatch(.successAuthentication)
        } else {
            passwordError = .text(message: Localizable.loginErrorPasswordWrong())
        }
    }
    
    // MARK: - Methods
    
    func tryLogin() {
        AnalyticsService.sendEvent(.submitLogin)
        passwordError = nil
        showProgress = true
        Task {
            do {
                try await authorizationService.login(email: email, password: password)
                await handleLoginResult(isSuccess: true)
            } catch {
                await handleLoginResult(isSuccess: false)
            }
        }
    }
    
    func sendResetEmail() {
        AnalyticsService.sendEvent(.tapResetPasswordEmail)
        Task {
            do {
                try await authorizationService.sendResetPasswordEmail(email)
                store.dispatch(.showNotificationBanner(.init(
                    title: Localizable.loginResetPasswordTitle(),
                    message: Localizable.loginResetPasswordMessage(email),
                    type: .success
                )))
            } catch {
                store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
            }
        }
    }
    
}
