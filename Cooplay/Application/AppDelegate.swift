//
//  AppDelegate.swift
//  Cooplay
//
//  Created by Alexandr on 19/09/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let store = ApplicationFactory.getStore()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        setupAppearance()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        store.dispatch(.processNotificationUserInfo(userInfo))
        print("Did receive remote notification: \(userInfo)")
    }
    
    // MARK: - Private Methods
    
    private func setupAppearance() {
        let navigationBarAppearance = UINavigationBar.appearance()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .clear
            appearance.backgroundColor = .clear
            appearance.shadowImage = UIImage()
            appearance.titleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            appearance.largeTitleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            navigationBarAppearance.standardAppearance = appearance
            navigationBarAppearance.compactAppearance = appearance
            navigationBarAppearance.scrollEdgeAppearance = appearance
        } else {
            navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
            navigationBarAppearance.barStyle = .blackOpaque
            navigationBarAppearance.barTintColor = .clear
            navigationBarAppearance.isTranslucent = true
            navigationBarAppearance.shadowImage = UIImage()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
        }
        
        navigationBarAppearance.tintColor = R.color.actionAccent()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        //processNotificationUserInfo(userInfo)
        print("Will present notification: \(userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        store.dispatch(.processNotificationUserInfo(userInfo))
        print("Did receive response with notification: \(userInfo)")
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        store.dispatch(.registerNotificationToken(fcmToken))
    }
    
}
