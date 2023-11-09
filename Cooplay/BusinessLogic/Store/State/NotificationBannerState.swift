//
//  NotificationBannerState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

final class NotificationBannerState {
    
    var banner: NotificationBanner?
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .showNotificationBanner(let banner):
            state.notificationBanner.banner = banner
            return state
        case .hideNotificationBanner:
            state.notificationBanner.banner = nil
            return state
        default:
            return state
        }
    }
}
