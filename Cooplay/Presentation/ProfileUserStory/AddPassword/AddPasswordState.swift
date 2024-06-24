//
//  AddPasswordState.swift
//  Cooplay
//
//  Created by Alexandr on 27.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

final class AddPasswordState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    private let appleAuthorizationService: AppleAuthorizationServiceType
    private var provider: AuthProvider = .password
    @Published var email: String
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var newPasswordError: TextFieldView.ErrorType? = .passwordValidation(
        types: [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
    )
    @Published var confirmPasswordError: TextFieldView.ErrorType?
    @Published var showProgress: Bool = false
    @Published var showGoogleAlert: Bool = false
    @Published var showAppleAlert: Bool = false
    var isReady: Bool {
        email.isEmail && newPasswordError?.isValid == true && newPassword == confirmPassword && !newPassword.isEmpty
    }
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, appleAuthorizationService: AppleAuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
        self.appleAuthorizationService = appleAuthorizationService
        email = authorizationService.userEmail ?? ""
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleReloginError() {
        showProgress = false
        guard let provider = authorizationService.getUserProviders().first else { return }
        
        self.provider = provider
        switch provider {
        case .password: break
        case .google: showGoogleAlert = true
        case .apple: showAppleAlert = true
        }
    }
    
    @MainActor private func handleResetResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            store.dispatch(.showNotificationBanner(.init(title: Localizable.addPasswordSuccessTitle(), type: .success)))
            close?()
        } else {
            store.dispatch(.showNotificationBanner(.init(title: Localizable.errorsUnknown(), type: .networkError)))
        }
    }
    
    // MARK: - Methods
    
    func checkPassword() {
        newPasswordError = .passwordValidation(types: Validation.password(newPassword))
    }
    
    func checkConfirmPassword() {
        guard !confirmPassword.isEmpty else {
            confirmPasswordError = nil
            return
        }
        
        confirmPasswordError = .text(
            message: newPassword != confirmPassword
                ? Localizable.registerErrorPasswordConfirmWrong()
                : nil
        )
    }
    
    func tryAddPassword() {
        showProgress = true
        AnalyticsService.sendEvent(.submitAddPassword)
        Task {
            do {
                switch provider {
                case .password:
                    try await authorizationService.addPassword(newPassword, email: email, provider: nil)
                case .google:
                    try await authorizationService.addPassword(newPassword, email: email, provider: .google)
                case .apple:
                    let creds = try await appleAuthorizationService.requestAuthorization()
                    try await authorizationService.addPassword(
                        newPassword, 
                        email: email,
                        provider: .apple(creds: creds, nonce: appleAuthorizationService.currentNonce)
                    )
                }
                await handleResetResult(isSuccess: true)
            } catch AuthorizationServiceError.needRelogin {
                await handleReloginError()
            } catch {
                await handleResetResult(isSuccess: false)
            }
        }
    }
    
}
