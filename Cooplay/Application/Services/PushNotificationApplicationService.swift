//
//  PushNotificationApplicationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 10/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import PluggableAppDelegate
import UserNotifications
import Firebase
import FirebaseMessaging

final class PushNotificationApplicationService: NSObject, ApplicationService {
    
    private var container: Container? {
        return ApplicationAssembly.assembler.resolver as? Container
    }
    private lazy var defaultsStorage = container!.resolve(DefaultsStorageType.self)!
    private lazy var userService = container!.resolve(UserServiceType.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Messaging.messaging().delegate = self
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if didAllow {
                Messaging.messaging().token { [weak self] token, _ in
                    if let token = token {
                        self?.registerToken(token)
                    } else {
                        print("Remote notifications token registeration error: Couldn't fetch registration token.")
                    }
                }
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
        registerCustomActions()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        processNotificationUserInfo(userInfo)
        print("Did receive remote notification: \(userInfo)")
    }
    
    private func processNotificationUserInfo(_ userInfo: [AnyHashable: Any]) {
//        guard let typeString = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: typeString) else { return }
//        switch notificationType {
//        case .statusRemind,
//             .eventStart:
//            guard let eventData = userInfo["event"] as? Data, let event = try? JSONDecoder().decode(Event.self, from: eventData) else { return }
//            let eventsViewController = EventsListBuilder().build()
//            let eventDetailsViewController = EventDetailsBuilder().build(with: event)
//            let navigationController = UINavigationController(rootViewController: eventsViewController)
//            navigationController.viewControllers = [eventsViewController, eventDetailsViewController]
//            UIApplication.setRootViewController(navigationController)
//        case .invitation:
//            guard let eventId = userInfo[GlobalConstant.eventIdKey] as? String else { return }
//            defaultsStorage.set(value: eventId, forKey: .inventLinkEventId)
//            NotificationCenter.default.post(name: .handleDeepLinkInvent, object: nil)
//        case .statusChange,
//             .takeEventOwner,
//             .addReaction:
//            guard
//                let eventJson = userInfo["event"] as? String,
//                let eventData =  eventJson.data(using: .utf16),
//                var event = try? JSONDecoder().decode(Event.self, from: eventData),
//                let userId = Auth.auth().currentUser?.uid,
//                let index = event.members.firstIndex(where: { $0.id == userId })
//            else { return }
//            let user = event.me
//            let me = event.members.remove(at: index)
//            event.me = me
//            event.members.append(user)
//            let eventsViewController = EventsListBuilder().build()
//            let eventDetailsViewController = EventDetailsBuilder().build(with: event)
//            let navigationController = UINavigationController(rootViewController: eventsViewController)
//            navigationController.viewControllers = [eventsViewController, eventDetailsViewController]
//            UIApplication.setRootViewController(navigationController)
//        default: break
//        }
    }
    
    private func registerToken(_ token: String) {
        userService.registerNotificationToken(token)
    }
    
    private func registerCustomActions() {
        //let status = UNNotificationAction(identifier: "Status", title: "Изменить статус")
        let category = UNNotificationCategory(identifier: "confirmStatus", actions: [], intentIdentifiers: [])
      
        UNUserNotificationCenter.current()
        .setNotificationCategories([category])
    }
}

extension PushNotificationApplicationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        //processNotificationUserInfo(userInfo)
        print("Will present notification: \(userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        processNotificationUserInfo(userInfo)
        print("Did receive response with notification: \(userInfo)")
        completionHandler()
    }
}

extension PushNotificationApplicationService: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        registerToken(fcmToken)
    }
}
