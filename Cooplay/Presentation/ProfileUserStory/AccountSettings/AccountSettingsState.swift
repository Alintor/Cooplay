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
    private let userService: UserServiceType
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
        userService.getEmailForProvider(.google)
    }
    var appleEmail: String? {
        userService.getEmailForProvider(.apple)
    }
    
    // MARK: - Init
    
    init(store: Store, userService: UserServiceType, appleAuthorizationService: AppleAuthorizationServiceType) {
        self.store = store
        self.userService = userService
        self.appleAuthorizationService = appleAuthorizationService
        providers = userService.getUserProviders()
    }
    
    // MARK: - Methods
    
    @MainActor private func hideProgress() {
        showProgress = false
    }
    
    @MainActor private func checkProviders() {
        providers = userService.getUserProviders()
    }
    
    func linkGoogleAccount() {
        showProgress = true
        Task {
            do {
                try await userService.linkGoogleProvider()
                await hideProgress()
                await checkProviders()
                store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkSuccessGoogle(), type: .success)))
            } catch {
                await hideProgress()
            }
        }
    }
    
    func linkAppleAccount() {
        showProgress = true
        Task {
            do {
                let creds = try await appleAuthorizationService.requestAuthorization()
                try await userService.linkAppleProvider(creds: creds, nonce: appleAuthorizationService.currentNonce)
                await hideProgress()
                await checkProviders()
                store.dispatch(.showNotificationBanner(.init(title: Localizable.accountLinkSuccessApple(), type: .success)))
            } catch {
                await hideProgress()
            }
        }
    }
    
    func unlinkProvider(_ provider: AuthProvider) {
        showProgress = true
        Task {
            do {
                try await userService.unlinkProvider(provider)
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
