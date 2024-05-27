//
//  AuthorizationMenuState.swift
//  Cooplay
//
//  Created by Alexandr on 15.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

final class AuthorizationMenuState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let authorizationService: AuthorizationServiceType
    private let appleAuthorizationService: AppleAuthorizationServiceType
    @Published var showProgress: Bool = false
    
    // MARK: - Init
    
    init(
        store: Store,
        authorizationService: AuthorizationServiceType,
        appleAuthorizationService: AppleAuthorizationServiceType
    ) {
        self.store = store
        self.authorizationService = authorizationService
        self.appleAuthorizationService = appleAuthorizationService
    }
    
    @MainActor private func hideProgress() {
        showProgress = false
    }
    
    // MARK: - Private Methods
    
    func signWithGoogle() {
        showProgress = true
        Task {
            do {
                try await authorizationService.signInWithGoogle()
                store.dispatch(.successAuthentication)
                await hideProgress()
            } catch {
                store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
                await hideProgress()
            }
        }
    }
    
    func signWithApple() {
        showProgress = true
        Task {
            do {
                let creds = try await appleAuthorizationService.requestAuthorization()
                try await authorizationService.signInWithApple(creds: creds, nonce: appleAuthorizationService.currentNonce)
                store.dispatch(.successAuthentication)
                await hideProgress()
            } catch {
                store.dispatch(.showNetworkError(AuthorizationServiceError.unknownError))
                await hideProgress()
            }
        }
    }
}
