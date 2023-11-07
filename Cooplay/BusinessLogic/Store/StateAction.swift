//
//  StoreAction.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

enum StateAction {
    // Authentication
    case successAuthentication
    case failureAuthentication(_ error: Error)
    case logout
    // Notification banner
    case showNotificationBanner(_ banner: NotificationBanner)
    case hideNotificationBanner
    case showNetworkError(_ error: Error)
    // User
    case updateProfile(_ profile: Profile)
    case startEditProfile
    case stopEditProfile
    case successEditingProfile
    case failureEditingProfile(_ error: Error)
    case editProfileActions(_ editActions: [EditAction])
}
