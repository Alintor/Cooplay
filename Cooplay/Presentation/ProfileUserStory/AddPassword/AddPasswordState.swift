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
    private let userService: UserServiceType
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var newPasswordError: TextFieldView.ErrorType? = .passwordValidation(
        types: [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
    )
    @Published var confirmPasswordError: TextFieldView.ErrorType?
    @Published var showProgress: Bool = false
    var isReady: Bool {
        newPasswordError?.isValid == true && newPassword == confirmPassword && !newPassword.isEmpty
    }
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store, userService: UserServiceType) {
        self.store = store
        self.userService = userService
    }
    
    // MARK: - Private Methods
    

    
    @MainActor private func handleResetResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            showProgress = false
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
                ? Localizable.registrationErrorPasswordConfirmWrong()
                : nil
        )
    }
    
    func tryAddPassword() {
        showProgress = true
        Task {
            do {
                try await userService.addPassword(newPassword)
                await handleResetResult(isSuccess: true)
            } catch {
                await handleResetResult(isSuccess: false)
            }
        }
    }
    
}
