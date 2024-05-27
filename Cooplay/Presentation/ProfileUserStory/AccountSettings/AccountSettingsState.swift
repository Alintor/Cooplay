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
    
    // MARK: - Init
    
    init(userService: UserServiceType, appleAuthorizationService: AppleAuthorizationServiceType) {
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
        print(providers.count)
    }
    
    func linkGoogleAccount() {
        showProgress = true
        Task {
            do {
                try await userService.linkGoogleProvider()
                await hideProgress()
                await checkProviders()
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
            } catch {
                await hideProgress()
            }
        }
    }
}
