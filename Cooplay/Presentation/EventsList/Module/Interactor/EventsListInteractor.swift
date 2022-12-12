//
//  EventsListInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation
import UIKit
import UserNotifications
import SwiftDate
import Kingfisher

enum EventsListError: Error {
    
    case unhandled(error: Error)
}

extension EventsListError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class EventsListInteractor {

    private let eventService: EventServiceType?
    private let userService: UserServiceType?
    private let defaultsStorage: DefaultsStorageType?
    
    init(eventService: EventServiceType?, userService: UserServiceType?, defaultsStorage: DefaultsStorageType?) {
        self.eventService = eventService
        self.userService = userService
        self.defaultsStorage = defaultsStorage
    }
}

// MARK: - EventsListInteractorInput

extension EventsListInteractor: EventsListInteractorInput {
    
    var showDeclinedEvents: Bool {
        return defaultsStorage?.get(valueForKey: .showDeclinedEvents) as? Bool ?? true
    }
    
    var inventLinkEventId: String? {
        return defaultsStorage?.get(valueForKey: .inventLinkEventId) as? String
    }
    
    func setDeclinedEvents(show: Bool) {
        defaultsStorage?.set(value: show, forKey: .showDeclinedEvents)
    }
    
    func clearInventLinkEventId() {
        defaultsStorage?.remove(valueForKey: .inventLinkEventId)
    }

    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void) {
        eventService?.fetchEvents { result in
            switch result {
            case .success(let events):
                completion(.success(events.sorted(by: { $0.date < $1.date })))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, EventsListError>) -> Void) {
        userService?.fetchProfile(completion: { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func addEvent(eventId: String, completion: @escaping (Result<Event, EventsListError>) -> Void) {
        eventService?.addEvent(eventId: eventId, completion: { (result) in
            switch result {
            case .success(let event):
                completion(.success(event))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventsListError>) -> Void) {
        eventService?.changeStatus(for: event, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func setupNotifications(events: [Event]) {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.removeAllPendingNotificationRequests()
        for event in events {
            if
                let coverPath = event.game.coverPath,
                let coverUrl = URL(string: coverPath) {
                KingfisherManager.shared.retrieveImage(with: coverUrl) { [weak self] (result) in
                    switch result {
                    case .success(let imageResult):
                        let attachment = UNNotificationAttachment.create(identifier: event.game.slug, image: imageResult.image, options: nil)
                        self?.addNotification(event: event, image: imageResult.image)
                    case .failure:
                        self?.addNotification(event: event, image: nil)
                    }
                }
                
            } else {
                addNotification(event: event, image: nil)
            }
        }
    }
    
    private func addNotification(event: Event, image: UIImage?) {
        let userNotificationCenter = UNUserNotificationCenter.current()
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
        userNotificationCenter.add(statusRequest)
        userNotificationCenter.add(eventStartRequest)
    }
    
    func updateAppBadge(inventedEventsCount: Int) {
        UIApplication.shared.applicationIconBadgeNumber = inventedEventsCount
    }
}
