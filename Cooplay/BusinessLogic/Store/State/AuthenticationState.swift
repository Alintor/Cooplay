//
//  AuthorizationState.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

final class AuthenticationState {
    
    var isAuthenticated: Bool
    var isAuthenticationInProgress = false
    
    init(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
    }
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .successAuthentication:
            state.authentication.isAuthenticationInProgress = false
            state.authentication.isAuthenticated = true
            return state
        case .failureAuthentication:
            state.authentication.isAuthenticationInProgress = false
            return state
        case .logout:
            state.authentication.isAuthenticated = false
            return state
        default:
            return state
        }
    }
}
