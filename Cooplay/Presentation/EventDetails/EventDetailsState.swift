//
//  EventDetailsState.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine

class EventDetailsState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let defaultsStorage: DefaultsStorageType
    @Published var event: Event
    
    // MARK: - Init
    
    init(store: Store, event: Event, defaultsStorage: DefaultsStorageType) {
        self.store = store
        self.event = event
        self.defaultsStorage = defaultsStorage
        store.state
            .map { $0.events.activeEvent }
            .replaceNil(with: event)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$event)
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
    
}
