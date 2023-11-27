//
//  HomeState.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine

class HomeState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    @Published var profile: Profile?
    @Published var activeEvent: Event?
    @Published var isShownProfile = false
    @Published var isNoEvents = false
    @Published var invitesCount: Int = 0
    var isActiveEventPresented: Bool {
        activeEvent != nil
    }
    
    // MARK: - Init
    
    init(store: Store) {
        self.store = store
        self.profile = nil
        store.state
            .map { $0.user.profile }
            .removeDuplicates {
                guard let profile1 = $0, let profile2 = $1 else { return false }
                return profile1.isEqual(profile2)
            }
            .assign(to: &$profile)
        store.state
            .map { $0.events.activeEvent }
            .removeDuplicates()
            .assign(to: &$activeEvent)
        store.state
            .map { $0.events.events.isEmpty }
            .removeDuplicates()
            .assign(to: &$isNoEvents)
        store.state
            .map { $0.events.inventedEvents.count }
            .removeDuplicates()
            .assign(to: &$invitesCount)
    }
    
    // MARK: - Methods
    
    func deselectEvent() {
        store.dispatch(.deselectEvent)
    }
    
    func fetchEvents() {
        store.dispatch(.fetchEvents)
    }
    
}
