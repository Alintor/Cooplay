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
    @Published var showChangeGameSheet = false
    @Published var showAddMembersSheet = false
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
        store.send(.changeStatus(status, event: event))
    }
    
    func addReaction(_ reaction: Reaction?, to member: User) {
        store.send(.addReaction(reaction, member: member, event: event))
    }
    
    func changeEditMode() {
        switch modeState {
        case .member, .owner:
            modeState = .edit
        case .edit:
            modeState = event.me.isOwner == true ? .owner : .member
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Haptic.play(style: .medium)
        }
    }
    
    func close() {
        store.send(.deselectEvent)
    }
    
    func sendMainReaction(to member: User) {
        guard let mainReaction = myReactions.first else { return }
        
        store.send(.addReaction(Reaction(style: .emoji, value: mainReaction), member: member, event: event))
    }
    
    func changeGame(_ game: Game) {
        store.send(.changeGame(game, event: event))
    }
    
    func addMembers(_ members: [User]) {
        store.send(.addMembers(members, event: event))
    }
    
}
