//
//  Notification.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static private let prefix = "com.ovchinnikov.ruwus.notification"
    static let handleDeepLinkInvent = Notification.Name("\(prefix).handleDeepLinkInvent")
    static let handleResetPassword = Notification.Name("\(prefix).handleResetPassword")
}
