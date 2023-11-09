//
//  StoreAction.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

enum StateAction {
    case showProgress
    case hideProgress
    // Authentication
    case successAuthentication
    case failureAuthentication(_ error: Error)
    case logout
    // Notification banner
    case showNotificationBanner(_ banner: NotificationBanner)
    case hideNotificationBanner
    case showNetworkError(_ error: Error)
    // Events
    case updateEvents(_ events: [Event])
    case updateActiveEvent(_ event: Event)
    case selectEvent(_ event: Event)
    case deselectEvent
    // User
    case updateProfile(_ profile: Profile)
    case editActions(_ editActions: [EditAction])
}