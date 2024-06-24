//
//  ChangePasswordState.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

final class ChangePasswordState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmPassword: String = ""
    @Published var currentPasswordError: TextFieldView.ErrorType?
    @Published var confirmPasswordError: TextFieldView.ErrorType?
    @Published var newPasswordError: TextFieldView.ErrorType? = .passwordValidation(
        types: [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
    )
    @Published var showProgress: Bool = false
    var isReady: Bool {
        !currentPassword.isEmpty && newPasswordError?.isValid == true && newPassword == confirmPassword
    }
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
    }
    
    // MARK: - Private Methods
    
    @MainActor private func handleSuccessChange() {
        showProgress = false
        store.dispatch(.showNotificationBanner(.init(title: Localizable.changePasswordSuccessTitle(), type: .success)))
        close?()
    }
    
    @MainActor private func handleWrongCurrentPassword() {
        showProgress = false
        currentPasswordError = .text(message: AuthorizationServiceError.wrongPassword.localizedDescription)
    }
    
    @MainActor private func handleFailureChange() {
        showProgress = false
        store.dispatch(.showNetworkError(AuthorizationServiceError.changePasswordError))
    }
    
    // MARK: - Methods
    
    func checkNewPassword() {
        newPasswordError = .passwordValidation(types: Validation.password(newPassword))
    }
    
    func checkConfirmPassword() {
        guard !confirmPassword.isEmpty else {
            confirmPasswordError = nil
            return
        }
        
        confirmPasswordError = .text(
            message: newPassword != confirmPassword
                ? Localizable.changePasswordErrorPasswordConfirmWrong()
                : nil
        )
    }
    
    func tryChangePassword() {
        showProgress = true
        AnalyticsService.sendEvent(.submitChangePassword)
        Task {
            do {
                try await authorizationService.changePassword(currentPassword: currentPassword, newPassword: newPassword)
                await handleSuccessChange()
            } catch AuthorizationServiceError.wrongPassword {
                await handleWrongCurrentPassword()
            } catch {
                await handleFailureChange()
            }
        }
    }
    
}
