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
    
    func fetchProfile(completion: @escaping (Result<User, EventsListError>) -> Void) {
        userService?.fetchProfile(completion: { result in
            switch result {
            case .success(let user):
                completion(.success(user))
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
                        self?.addNotification(event: event, attachment: attachment)
                    case .failure:
                        self?.addNotification(event: event, attachment: nil)
                    }
                }
                
            } else {
                addNotification(event: event, attachment: nil)
            }
        }
    }
    
    private func addNotification(event: Event, attachment: UNNotificationAttachment?) {
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = R.string.localizable.notificationsStatusRemindTitle()
        notificationContent.body = R.string.localizable.notificationsStatusRemindMessage(30, event.game.name)
        notificationContent.userInfo = [
            "type": NotificationType.statusRemind.rawValue
        ]
        if let eventData = try? JSONEncoder().encode(event) {
            notificationContent.userInfo["event"] = eventData
        }
        if let attachment = attachment {
            notificationContent.attachments = [attachment]
        }
        let triggerDate = Calendar.current.dateComponents(
            [.year,.month,.day,.hour,.minute,.second,],
            from: event.date - 30.minutes
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: event.id, content: notificationContent, trigger: trigger)
        userNotificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func updateAppBadge(inventedEventsCount: Int) {
        UIApplication.shared.applicationIconBadgeNumber = inventedEventsCount
    }
}
