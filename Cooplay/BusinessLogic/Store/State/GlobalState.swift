//
//  GlobalState.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

final class GlobalState {
    
    var authentication: AuthenticationState
    var notificationBanner = NotificationBannerState()
    var events = EventsState()
    var user = UserState()
    
    init(isAuthenticated: Bool) {
        self.authentication = AuthenticationState(isAuthenticated: isAuthenticated)
    }
    
}
