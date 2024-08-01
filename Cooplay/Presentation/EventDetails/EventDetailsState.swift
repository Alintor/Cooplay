//
//  EventDetailsState.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation

class EventDetailsState: ObservableObject {
    
    enum ModeState {
        
        case edit
        case owner
        case member
        
        var isEditMode: Bool {
            self == .edit
        }
    }
    
    // MARK: - Properties
    
    private let store: Store
    private let defaultsStorage: DefaultsStorageType
    @Published var event: Event
    @Published var modeState: ModeState
    @Published var eventDetailsSize: CGSize = .zero
    @Published var needShowDateSelection = false
    @Published var newDate: Date
    var members: [User] {
        event.members
        .sorted(by: { $0.name < $1.name })
        .sorted(by: { $0.isOwner == true && $1.isOwner != true})
    }
    
    // MARK: - Init
    
    init(store: Store, event: Event, defaultsStorage: DefaultsStorageType) {
        self.store = store
        self.event = event
        self.defaultsStorage = defaultsStorage
        self.modeState = event.me.isOwner == true ? .owner : .member
        self.newDate = event.date
        store.state
            .map { $0.events.activeEvent }
            .replaceNil(with: event)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$event)
        store.state
            .map { $0.events.activeEvent?.me.isOwner == true ? .owner : .member }
            .replaceNil(with: event.me.isOwner == true ? .owner : .member)
            .removeDuplicates()
            .assign(to: &$modeState)
    }
    
    // MARK: - Computed
    
    var myReactions: [String] {
        defaultsStorage.get(valueForKey: .reactions) as? [String] ?? GlobalConstant.defaultsReactions
    }
    
    // MARK: - Methods
    
    func changeStatus(_ status: User.Status) {
        AnalyticsService.sendEvent(.changeStatusFromEventDetails, parameters: ["status": status.title])
        store.dispatch(.changeStatus(status, event: event))
    }
    
    func addReaction(_ reaction: Reaction?, to member: User) {
        store.dispatch(.addReaction(reaction, member: member, event: event))
    }
    
    func changeEditMode() {
        switch modeState {
        case .member, .owner:
            AnalyticsService.sendEvent(.showEventDetailsEditMode)
            modeState = .edit
        case .edit:
            modeState = event.me.isOwner == true ? .owner : .member
            needShowDateSelection = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Haptic.play(style: .medium)
        }
    }
    
    func showDateSelection() {
        newDate = event.date
        needShowDateSelection = true
    }
    
    func close() {
        store.dispatch(.deselectEvent)
    }
    
    func sendMainReaction(to member: User) {
        guard let mainReaction = myReactions.first else { return }
        
        store.dispatch(.addReaction(Reaction(style: .emoji, value: mainReaction), member: member, event: event))
    }
    
    func changeGame(_ game: Game) {
        AnalyticsService.sendEvent(.submitChangeEventGame)
        store.dispatch(.changeGame(game, event: event))
    }
    
    func changeDate() {
        guard newDate != event.date else { return }
        
        AnalyticsService.sendEvent(.submitChangeEventDate)
        store.dispatch(.changeDate(newDate, event: event))
    }
    
    func addMembers(_ members: [User]) {
        AnalyticsService.sendEvent(.submitAddEventMember)
        store.dispatch(.addMembers(members, event: event))
    }
    
    func deleteEvent() {
        store.dispatch(.deleteEvent(event))
    }
    
    func handleMemberAction(_ action: MemberContextAction, member: User) {
        switch action {
        case .makeOwner:
            store.dispatch(.makeOwner(member, event: event))
        case .remove:
            store.dispatch(.removeMember(member, event: event))
        }
    }
    
}
