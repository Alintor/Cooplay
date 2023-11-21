//
//  NotificationsService.swift
//  Cooplay
//
//  Created by Alexandr on 21.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications
import FirebaseMessaging
import SwiftDate
import Kingfisher

final class NotificationsService {
    
    private let notificationCenter: UNUserNotificationCenter
    private let firebaseAuth: Auth
    private var inventedEventId: String?
    
    // MARK: - Init
    
    init(
        notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current(),
        firebaseAuth: Auth = Auth.auth()
    ) {
        self.notificationCenter = notificationCenter
        self.firebaseAuth = firebaseAuth
    }
    
    // MARK: - Private Methods
    
    private func setupLocalNotifications(events: [Event]) {
        notificationCenter.removeAllPendingNotificationRequests()
        for event in events {
            if
                let coverPath = event.game.coverPath,
                let coverUrl = URL(string: coverPath) {
                KingfisherManager.shared.retrieveImage(with: coverUrl) { [weak self] (result) in
                    switch result {
                    case .success(let imageResult):
                        let attachment = UNNotificationAttachment.create(identifier: event.game.slug, image: imageResult.image, options: nil)
                        self?.addLocalNotification(event: event, image: imageResult.image)
                    case .failure:
                        self?.addLocalNotification(event: event, image: nil)
                    }
                }
                
            } else {
                addLocalNotification(event: event, image: nil)
            }
        }
    }
    
    private func addLocalNotification(event: Event, image: UIImage?) {
        let statusNotificationContent = UNMutableNotificationContent()
        let eventStartNotificationContent = UNMutableNotificationContent()
        statusNotificationContent.title = R.string.localizable.notificationsStatusRemindTitle()
        eventStartNotificationContent.title = R.string.localizable.notificationsEventStartRemindTitle()
        statusNotificationContent.body = R.string.localizable.notificationsStatusRemindMessage(GlobalConstant.eventConfirmPeriodMinutes, event.game.name)
        eventStartNotificationContent.body = R.string.localizable.notificationsEventStartRemindMessage(event.game.name)
        statusNotificationContent.userInfo = [
            "type": NotificationType.statusRemind.rawValue
        ]
        statusNotificationContent.categoryIdentifier = "confirmStatus"
        eventStartNotificationContent.userInfo = [
            "type": NotificationType.statusRemind.rawValue
        ]
        eventStartNotificationContent.categoryIdentifier = "confirmStatus"
        if let eventData = try? JSONEncoder().encode(event) {
            statusNotificationContent.userInfo["event"] = eventData
            eventStartNotificationContent.userInfo["event"] = eventData
        }
        if let image = image {
            if let attachment = UNNotificationAttachment.create(identifier: "0\(event.game.slug)", image: image, options: nil) {
                statusNotificationContent.attachments = [attachment]
            }
            if let attachment = UNNotificationAttachment.create(identifier: "1\(event.game.slug)", image: image, options: nil) {
                eventStartNotificationContent.attachments = [attachment]
            }
        }
        
        let statusTriggerDate = Calendar.current.dateComponents(
            [.year,.month,.day,.hour,.minute,.second,],
            from: event.date - GlobalConstant.eventConfirmPeriodMinutes.minutes
        )
        let eventStartTriggerDate = Calendar.current.dateComponents(
            [.year,.month,.day,.hour,.minute,.second,],
            from: event.date
        )
        let statusTrigger = UNCalendarNotificationTrigger(dateMatching: statusTriggerDate, repeats: false)
        let eventStartTrigger = UNCalendarNotificationTrigger(dateMatching: eventStartTriggerDate, repeats: false)
        let statusRequest = UNNotificationRequest(identifier: "Confirm-\(event.id)", content: statusNotificationContent, trigger: statusTrigger)

        let eventStartRequest = UNNotificationRequest(identifier: "Start-\(event.id)", content: eventStartNotificationContent, trigger: eventStartTrigger)
        notificationCenter.add(statusRequest)
        notificationCenter.add(eventStartRequest)
    }
    
    private func updateAppBadge(inventedEventsCount: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = inventedEventsCount
        }
    }
    
}


extension NotificationsService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .successAuthentication:
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            notificationCenter.requestAuthorization(options: options) {
                (didAllow, error) in
                if didAllow {
                    Messaging.messaging().token {token, _ in
                        if let token = token {
                            store.dispatch(.registerNotificationToken(token))
                        } else {
                            print("Remote notifications token registeration error: Couldn't fetch registration token.")
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        case .logout:
            notificationCenter.removeAllPendingNotificationRequests()
            
        case .processNotificationUserInfo(let userInfo):
            guard let typeString = userInfo["type"] as? String, let notificationType = NotificationType(rawValue: typeString) else { return }
            switch notificationType {
            case .statusRemind,
                 .eventStart:
                guard 
                    let eventData = userInfo["event"] as? Data,
                    let event = try? JSONDecoder().decode(Event.self, from: eventData)
                else { return }
                
                store.dispatch(.selectEvent(event))
            case .invitation:
                guard let eventId = userInfo[GlobalConstant.eventIdKey] as? String else { return }
                
                self.inventedEventId = eventId
                //defaultsStorage.set(value: eventId, forKey: .inventLinkEventId)
                //NotificationCenter.default.post(name: .handleDeepLinkInvent, object: nil)
            case .statusChange,
                 .takeEventOwner,
                 .addReaction:
                guard
                    let eventJson = userInfo["event"] as? String,
                    let eventData =  eventJson.data(using: .utf16),
                    var event = try? JSONDecoder().decode(Event.self, from: eventData),
                    let userId = Auth.auth().currentUser?.uid,
                    let index = event.members.firstIndex(where: { $0.id == userId })
                else { return }
                let user = event.me
                let me = event.members.remove(at: index)
                event.me = me
                event.members.append(user)
                store.dispatch(.selectEvent(event))
            default: break
            }
            
        case .updateEvents(let events):
            let acceptedEvents = events.filter({ $0.me.state != .unknown && $0.me.state != .declined })
            let inventedEvents = events.filter({ $0.me.state == .unknown })
            setupLocalNotifications(events: acceptedEvents)
            updateAppBadge(inventedEventsCount: inventedEvents.count)
            if let event = events.first(where: { $0.id == self.inventedEventId }) {
                inventedEventId = nil
                store.dispatch(.selectEvent(event))
            }
            
        default: break
        }
    }
}
