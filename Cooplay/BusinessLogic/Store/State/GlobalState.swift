//
//  GlobalState.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

class GlobalState {
    
    var authentication: AuthenticationState
    var notificationBanner = NotificationBannerState()
    var user = UserState()
    var isInProgress = false
    
    init(isAuthenticated: Bool) {
        self.authentication = AuthenticationState(isAuthenticated: isAuthenticated)
    }
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .showProgress:
            state.isInProgress = true
            return state
        case .hideProgress:
            state.isInProgress = false
            return state
        default:
            return state
        }
    }
    
}
