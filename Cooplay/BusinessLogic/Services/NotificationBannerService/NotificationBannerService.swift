//
//  NotificationBannerService.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

final class NotificationBannerService: StateEffect {
    
    func perform(store: Store, action: StateAction) {
        switch action {
        case .showNotificationBanner(let banner):
            DispatchQueue(label: "notificationBannerService", qos: .default).asyncAfter(deadline: .now() + banner.duration) {
                store.send(.hideNotificationBanner)
            }
        case .showNetworkError(let error):
            store.send(.showNotificationBanner(.init(
                message: error.localizedDescription,
                type: .networkError
            )))
        default: break
        }
    }
}
