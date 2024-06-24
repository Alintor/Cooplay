//
//  NotificationBannerService.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

final class NotificationBannerService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .showNotificationBanner(let banner):
            DispatchQueue(label: "notificationBannerService", qos: .default).asyncAfter(deadline: .now() + banner.duration) {
                store.dispatch(.hideNotificationBanner)
            }
        case .showNetworkError(let error):
            AnalyticsService.sendEvent(.showNetworkError, parameters: ["message": error.localizedDescription])
            store.dispatch(.showNotificationBanner(.init(
                title: error.localizedDescription,
                type: .networkError
            )))
        default: break
        }
    }
}
