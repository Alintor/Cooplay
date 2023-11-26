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
    
    static func reducer(state: GlobalState, action: StoreAction) -> GlobalState {
        switch action {
        case .updateEvents(let events):
            state.events.events = events
            if let activeEvent = state.events.activeEvent, !events.contains(where: { $0.id == activeEvent.id }) {
                state.events.activeEvent = nil
            }
            return state
            
        case .updateActiveEvent(let event),
             .selectEvent(let event):
            state.events.activeEvent = event
            return state
            
        case .deselectEvent:
            state.events.activeEvent = nil
            return state
            
        case .changeStatus(let status, let event):
            if state.events.activeEvent?.id == event.id {
                state.events.activeEvent?.me.status = status
            }
            if let index = state.events.events.firstIndex(where: { $0.id == event.id }) {
                var targetEvent = state.events.events[index]
                targetEvent.me.status = status
                state.events.events[index] = targetEvent
                if case .accepted = status, state.events.events.count == 1 {
                    state.events.activeEvent = targetEvent
                }
            }
            return state
            
        case .addReaction(let reaction, let member, let event):
            guard var activeEvent = state.events.activeEvent, activeEvent.id == event.id else { return state }
            if member == activeEvent.me {
                var reactions = activeEvent.me.reactions ?? [:]
                reactions[activeEvent.me.id] = reaction
                activeEvent.me.reactions = reactions
                state.events.activeEvent = activeEvent
            }
            if let index = activeEvent.members.firstIndex(of: member) {
                var reactions = activeEvent.members[index].reactions ?? [:]
                reactions[activeEvent.me.id] = reaction
                activeEvent.members[index].reactions = reactions
                state.events.activeEvent = activeEvent
            }
            return state
            
        case .changeGame(let game, let event):
            if state.events.activeEvent?.id == event.id {
                state.events.activeEvent?.game = game
            }
            if let index = state.events.events.firstIndex(where: { $0.id == event.id }) {
                var targetEvent = state.events.events[index]
                targetEvent.game = game
                state.events.events[index] = targetEvent
            }
            return state
            
        case .changeDate(let date, let event):
            if state.events.activeEvent?.id == event.id {
                state.events.activeEvent?.date = date
            }
            if let index = state.events.events.firstIndex(where: { $0.id == event.id }) {
                var targetEvent = state.events.events[index]
                targetEvent.date = date
                state.events.events[index] = targetEvent
            }
            return state
            
        default:
            return state
        }
    }
    
}
