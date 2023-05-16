//
//  EventsListContract.swift
//  Cooplay
//
//  Created by Alexandr on 13.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import DTModelStorage

// MARK: - View

protocol EventsListViewInput: AnyObject, ActivityIndicatorRenderer {

    func setupInitialState()
    func updateProfile(with model: AvatarViewModel)
    func showItems()
}

protocol EventsListViewOutput: AnyObject {
    
    func didLoad()
    func didAppear()
    func didTapProfile()
    func setDataSource(_ dataSource: MemoryStorage)
    func didSelectItem(_ event: Event)
    func didTapNewEvent()
}

// MARK: - Interactor

protocol EventsListInteractorInput: AnyObject {

    var showDeclinedEvents: Bool { get }
    var inventLinkEventId: String? { get }
    func setDeclinedEvents(show: Bool)
    func clearInventLinkEventId()
    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void)
    func fetchProfile(completion: @escaping (Result<Profile, EventsListError>) -> Void)
    func addEvent(eventId: String, completion: @escaping (Result<Event, EventsListError>) -> Void)
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventsListError>) -> Void
    )
    func setupNotifications(events: [Event])
    func updateAppBadge(inventedEventsCount: Int)
}

// MARK: - Router

protocol EventsListRouterInput: ContextMenuRouter {

    func openEvent(_ event: Event)
    func openNewEvent()
    func openProfile(with user: Profile)
}

// MARK: - Module Input

protocol EventsListModuleInput: AnyObject { }
