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
    
    // MARK: - Init
    
    init(store: Store = ApplicationFactory.getStore()) {
        self.store = store
        self.isAuthenticated = store.state.value.authentication.isAuthenticated
        store.state
            .map { $0.authentication.isAuthenticated }
            .removeDuplicates()
            .assign(to: &$isAuthenticated)
    }
    
    // MARK: - Methods
    
    func handleDeepLink(_ url: URL) {
        store.dispatch(.handleDeepLink(url))
    }
    
}
