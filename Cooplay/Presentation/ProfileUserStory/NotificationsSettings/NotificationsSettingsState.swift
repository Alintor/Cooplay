//
//  NotificationsSettingsState.swift
//  Cooplay
//
//  Created by Alexandr on 11.04.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

class NotificationsSettingsState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let userService: UserServiceType
    private let notificationCenter: UNUserNotificationCenter
    @Published var notificationsInfo: NotificationsInfo = NotificationsInfo()
    @Published var isNotificationsAllowed: Bool = true
    var showPermissionView: Bool {
        return notificationsInfo.enableNotifications && !isNotificationsAllowed
    }
    
    // MARK: - Init
    
    init(store: Store, userService: UserServiceType, notificationCenter: UNUserNotificationCenter) {
        self.store = store
        self.userService = userService
        self.notificationCenter = notificationCenter
        store.state
            .map { $0.user.profile?.notificationsInfo }
            .replaceNil(with: notificationsInfo)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$notificationsInfo)
    }
    
    // MARK: - Methods
    
    @MainActor private func updatePermissionStatus(_ isAllowed: Bool) {
        isNotificationsAllowed = isAllowed
    }
    
    func updateInfo() {
        userService.updateNotificationsInfo(notificationsInfo)
    }
    
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
        else { return }
        
        UIApplication.shared.open(settingsURL)
    }
    
    func checkPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        Task {
            let isAllowed = try await notificationCenter.requestAuthorization(options: options)
            await updatePermissionStatus(isAllowed)
        }
    }
}
