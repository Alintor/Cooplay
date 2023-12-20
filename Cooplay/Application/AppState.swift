//
//  AppState.swift
//  Cooplay
//
//  Created by Alexandr on 20.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation

class AppState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    @Published var isAuthenticated: Bool
    @Published var notificationBanner: NotificationBanner?
    
    // MARK: - Init
    
    init(store: Store = ApplicationFactory.getStore()) {
        self.store = store
        self.isAuthenticated = store.state.value.authentication.isAuthenticated
        self.notificationBanner = store.state.value.notificationBanner.banner
        store.state
            .map { $0.authentication.isAuthenticated }
            .removeDuplicates()
            .assign(to: &$isAuthenticated)
        store.state
            .map { $0.notificationBanner.banner }
            .removeDuplicates()
            .assign(to: &$notificationBanner)
    }
    
    // MARK: - Methods
    
    func handleDeepLink(_ url: URL) {
        store.dispatch(.handleDeepLink(url))
    }
    
    func hideNotificationBanner() {
        store.dispatch(.hideNotificationBanner)
    }
    
}
