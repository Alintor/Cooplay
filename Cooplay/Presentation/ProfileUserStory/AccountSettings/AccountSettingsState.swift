//
//  AccountSettingsState.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

final class AccountSettingsState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    private let appleAuthorizationService: AppleAuthorizationServiceType
    @Published var providers: [AuthProvider]
    @Published var showProgress: Bool = false
    var showChangePassword: Bool {
        providers.contains { $0 == .password }
    }
    var showLinkGoogle: Bool {
        !providers.contains { $0 == .google }
    }
    var showLinkApple: Bool {
        !providers.contains { $0 == .apple }
    }
    var showUnlink: Bool {
        providers.count > 1
    }
    var googleEmail: String? {
        authorizationService.getEmailForProvider(.google)
    }
    var appleEmail: String? {
        authorizationService.getEmailForProvider(.apple)
    }
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType, appleAuthorizationService: AppleAuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
        self.appleAuthorizationService = appleAuthorizationService
        providers = authorizationService.getUserProviders()
    }
    
    // MARK: - Methods
    
    @MainActor private func hideProgress() {
        showProgress = false
    }
    
    @MainActor private func checkProviders() {
        providers = authorizationService.getUserProviders()
    }
    
    @MainActor private func handleError(_ error: Error) {
        showProgress = false
        guard let serviceError = error as? AuthorizationServiceError else {
            store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkError(), type: .networkError)))
            return
        }
        
        switch serviceError {
        case .emailAlreadyInUse, .credentialAlreadyInUse:
            store.dispatch(.showNotificationBanner(.init(
                title: Localizable.accountLinkError(),
                message: serviceError.localizedDescription,
                type: .networkError
            )))
        default:
            store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkError(), type: .networkError)))
        }
    }
    
    func linkGoogleAccount() {
        showProgress = true
        AnalyticsService.sendEvent(.tapLinkGoogle)
        Task {
            do {
                try await authorizationService.linkGoogleProvider()
                await hideProgress()
                await checkProviders()
                store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkSuccessGoogle(), type: .success)))
            } catch {
                await handleError(error)
            }
        }
    }
    
    func linkAppleAccount() {
        showProgress = true
        AnalyticsService.sendEvent(.tapLinkApple)
        Task {
            do {
                let creds = try await appleAuthorizationService.requestAuthorization()
                try await authorizationService.linkAppleProvider(creds: creds, nonce: appleAuthorizationService.currentNonce)
                await hideProgress()
                await checkProviders()
                store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkSuccessApple(), type: .success)))
            } catch {
                await handleError(error)
            }
        }
    }
    
    func unlinkProvider(_ provider: AuthProvider) {
        showProgress = true
        Task {
            do {
                try await authorizationService.unlinkProvider(provider)
                await hideProgress()
                await checkProviders()
                switch provider {
                case .google:
                    store.dispatch(.showNotificationBanner(.init(title: Localizable.accountUnlinkSuccessGoogle(), type: .success)))
                case .apple:
                    store.dispatch(.showNotificationBanner(.init(title: Localizable.accountUnlinkSuccessApple(), type: .success)))
                default: break
                }
            } catch {
                await hideProgress()
            }
        }
    }
}
