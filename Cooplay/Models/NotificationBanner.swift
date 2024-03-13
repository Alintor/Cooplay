//
//  NotificationBanner.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NotificationBanner {
    
    enum NotificationType {
        
        case networkError
        case success
    }
    
    let title: String
    let message: String?
    let type: NotificationType
    let duration: TimeInterval
    
    init(title: String, message: String? = nil, type: NotificationType, duration: TimeInterval = 3) {
        self.title = title
        self.message = message
        self.type = type
        self.duration = duration
    }
}

extension NotificationBanner: Equatable {
    
}
