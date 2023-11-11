//
//  EventsListState.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine

class EventsListState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let newEventAction: (() -> Void)?
    @Published var invitedEvents: [Event]
    @Published var acceptedEvents: [Event]
    @Published var declinedEvents: [Event]
    
    // MARK: - Init
    
    init(store: Store, newEventAction: (() -> Void)?) {
        self.store = store
        self.newEventAction = newEventAction
        invitedEvents = store.state.value.events.inventedEvents
        acceptedEvents = store.state.value.events.acceptedEvents
        declinedEvents = store.state.value.events.declinedEvents
        store.state
            .map { $0.events.inventedEvents }
            .removeDuplicates { oldEvents, newEvents in
                oldEvents.elementsEqual(newEvents) {
                    $0.isEqual($1)
                }
            }
            .assign(to: &$invitedEvents)
        store.state
            .map { $0.events.acceptedEvents }
            .removeDuplicates { oldEvents, newEvents in
                oldEvents.elementsEqual(newEvents) {
                    $0.isEqual($1)
                }
            }
            .assign(to: &$acceptedEvents)
        store.state
            .map { $0.events.declinedEvents }
            .removeDuplicates { oldEvents, newEvents in
                oldEvents.elementsEqual(newEvents) {
                    $0.isEqual($1)
                }
            }
            .assign(to: &$declinedEvents)
    }
    
    // MARK: - Methods
    
    func selectEvent(_ event: Event) {
        store.send(.selectEvent(event))
    }
    
    func changeStatus(_ status: User.Status, for event: Event) {
        store.send(.changeStatus(status, event: event))
    }
    
    func openNewEvent() {
        newEventAction?()
    }
}
