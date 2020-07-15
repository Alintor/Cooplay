//
//  EventsListInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation

protocol EventsListInteractorInput: class {

    var showDeclinedEvents: Bool { get }
    var inventLinkEventId: String? { get }
    func setDeclinedEvents(show: Bool)
    func clearInventLinkEventId()
    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void)
    func fetchProfile(completion: @escaping (Result<User, EventsListError>) -> Void)
    func addEvent(eventId: String, completion: @escaping (Result<Event, EventsListError>) -> Void)
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventsListError>) -> Void
    )
    func setupNotifications(events: [Event])
    func updateAppBadge(inventedEventsCount: Int)
}
