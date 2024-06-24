//
//  ResetPasswordState.swift
//  Cooplay
//
//  Created by Alexandr on 19.04.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

final class ResetPasswordState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    private let oobCode: String
    @Published var email: String?
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var newPasswordError: TextFieldView.ErrorType? = .passwordValidation(
        types: [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
    )
    @Published var confirmPasswordError: TextFieldView.ErrorType?
    @Published var showProgress: Bool = false
    @Published var showExpiredView: Bool = false
    var isReady: Bool {
        newPasswordError?.isValid == true && newPassword == confirmPassword && !newPassword.isEmpty
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, oobCode: String) {
        self.store = store
        self.authorizationService = authorizationService
        self.oobCode = oobCode
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleEmailFetching(fetchedEmail: String?) {
        showProgress = false
        if let fetchedEmail {
            email = fetchedEmail
        } else {
            showExpiredView = true
        }
    }
    
    @MainActor private func handleResetResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            store.dispatch(.showNotificationBanner(.init(title: Localizable.resetPasswordResetSuccess(), type: .success)))
            store.dispatch(.successAuthentication)
        } else {
            store.dispatch(.showNotificationBanner(.init(title: Localizable.resetPasswordResetFailure(), type: .networkError)))
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
    
    func fetchEmail() {
        showProgress = true
        Task {
            do {
                let email = try await authorizationService.fetchResetEmail(oobCode: oobCode)
                await handleEmailFetching(fetchedEmail: email)
            } catch {
                await handleEmailFetching(fetchedEmail: nil)
            }
        }
    }
    
    func tryResetPassword() {
        guard let email else { return }
        
        showProgress = true
        AnalyticsService.sendEvent(.submitResetPassword)
        Task {
            do {
                try await authorizationService.resetPassword(newPassword: newPassword, oobCode: oobCode)
                try await authorizationService.login(email: email, password: newPassword)
                await handleResetResult(isSuccess: true)
            } catch {
                await handleResetResult(isSuccess: false)
            }
        }
    }
    
}
