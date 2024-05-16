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
    @Published var showProgress: Bool = false
    
    // MARK: - Init
    
    init(store: Store, authorizationService: AuthorizationServiceType) {
        self.store = store
        self.authorizationService = authorizationService
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
}
