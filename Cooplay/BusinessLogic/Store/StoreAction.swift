//
//  StoreAction.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

enum StoreAction {
    // Authentication
    case successAuthentication
    case failureAuthentication(_ error: Error)
    case logout
    // Notification banner
    case showNotificationBanner(_ banner: NotificationBanner)
    case hideNotificationBanner
    case showNetworkError(_ error: Error)
    // Events
    case fetchEvents
    case updateEvents(_ events: [Event])
    case updateActiveEvent(_ event: Event)
    case selectEvent(_ event: Event)
    case deselectEvent
    case changeStatus(_ status: User.Status, event: Event)
    case addReaction(_ reaction: Reaction?, member: User, event: Event)
    case deleteEvent(_ event: Event)
    case changeGame(_ game: Game, event: Event)
    case changeDate(_ date: Date, event: Event)
    case addMembers(_ members: [User], event: Event)
    case removeMember(_ member: User, event: Event)
    case makeOwner(_ member: User, event: Event)
    // User
    case updateProfile(_ profile: Profile)
    case editActions(_ editActions: [EditAction])
    case showProfileProgress
    case hideProfileProgress
    // Notifications
    case registerNotificationToken(_ token: String)
    case processNotificationUserInfo(_ userInfo: [AnyHashable: Any])
}
