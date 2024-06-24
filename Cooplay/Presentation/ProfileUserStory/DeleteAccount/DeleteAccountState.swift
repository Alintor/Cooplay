//
//  DeleteAccountState.swift
//  Cooplay
//
//  Created by Alexandr on 29.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

final class DeleteAccountState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    private let appleAuthorizationService: AppleAuthorizationServiceType
    @Published var showProgress: Bool = false
    @Published var provider: AuthProvider?
    var showPassword: Bool {
        provider == .password
    }
    @Published var password = ""
    @Published var passwordError: TextFieldView.ErrorType?
    var isButtonActive: Bool {
        switch provider {
        case .password:
            return !password.isEmpty
        default: return true
        }
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, appleAuthorizationService: AppleAuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
        self.appleAuthorizationService = appleAuthorizationService
        self.provider = authorizationService.getUserProviders().first
    }
    
    // MARK: - Methods
    
    func tryDeleteAccount() {
        showProgress = true
        AnalyticsService.sendEvent(.submitDeleteAccount)
        Task {
            do {
                switch provider {
                case .password:
                    try await authorizationService.deleteAccount(provider: .password(password))
                case .google:
                    try await authorizationService.deleteAccount(provider: .google)
                case .apple:
                    let creds = try await appleAuthorizationService.requestAuthorization()
                    try await authorizationService.deleteAccount(provider: .apple(creds: creds, nonce: appleAuthorizationService.currentNonce))
                case nil:
                    throw AuthorizationServiceError.unknownError
                }
                store.dispatch(.showNotificationBanner(.init(title: Localizable.deleteAccountSuccessTitle(), type: .success)))
                store.dispatch(.logout)
            } catch AuthorizationServiceError.wrongPassword {
                await MainActor.run {
                    showProgress = false
                    passwordError = .text(message: AuthorizationServiceError.wrongPassword.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    showProgress = false
                    store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
                }
            }
        }
    }
    
}
