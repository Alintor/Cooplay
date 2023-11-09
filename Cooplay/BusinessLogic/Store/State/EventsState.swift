//
//  EventsState.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

final class EventsState {
    
    var events = [Event]()
    var activeEvent: Event?
    
    var inventedEvents: [Event] {
        return events.filter({ $0.me.state == .unknown })
    }
    var acceptedEvents: [Event] {
        return events.filter({ $0.me.state != .unknown && $0.me.state != .declined })
    }
    var declinedEvents: [Event] {
        return events.filter({ $0.me.state == .declined })
    }
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .updateEvents(let events):
            state.events.events = events
            return state
        case .updateActiveEvent(let event):
            state.events.activeEvent = event
            return state
        case .selectEvent(let event):
            state.events.activeEvent = event
            return state
        case .deselectEvent:
            state.events.activeEvent = nil
            return state
        default:
            return state
        }
    }
    
}
