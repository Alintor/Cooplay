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

final class PushNotificationApplicationService: NSObject, ApplicationService {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        return true
    }
    
    private func processNotificationUserInfo(_ userInfo: [AnyHashable: Any]) {
        guard let typeString = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: typeString) else { return }
        switch notificationType {
        case .statusRemind:
            guard let eventData = userInfo["event"] as? Data, let event = try? JSONDecoder().decode(Event.self, from: eventData) else { return }
            let eventsViewController = R.storyboard.eventsList.eventsListViewController()!
            let eventDetailsViewController = R.storyboard.eventDetails.eventDetailsViewController()!
            eventDetailsViewController.output?.configure(with: event)
            let navigationController = UINavigationController(rootViewController: eventsViewController)
            navigationController.viewControllers = [eventsViewController, eventDetailsViewController]
            UIApplication.setRootViewController(navigationController)
        default:
            break
        }
    }
}

extension PushNotificationApplicationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        processNotificationUserInfo(userInfo)
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
