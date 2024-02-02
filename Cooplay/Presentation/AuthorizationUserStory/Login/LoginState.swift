//
//  AuthorizationState.swift
//  Cooplay
//
//  Created by Alexandr on 29.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

class LoginState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var isEmailCorrect: Bool = false
    @Published var showEmailChecking: Bool = false
    @Published var showProgress: Bool = false
    var isReady: Bool {
        isEmailCorrect && !password.isEmpty
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleEmailChecking(isExist: Bool) {
        showEmailChecking = false
        isEmailCorrect = isExist
        emailError = isExist ? nil : Localizable.authorizationErrorEmailNotExist()
    }
    
    @MainActor private func handleLoginResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            store.dispatch(.successAuthentication)
        } else {
            passwordError = Localizable.authorizationErrorPasswordWrong()
        }
    }
    
    // MARK: - Methods
    
    func checkEmail() {
        guard email.isEmail else { return }
        
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
    
    func tryLogin() {
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
    
}