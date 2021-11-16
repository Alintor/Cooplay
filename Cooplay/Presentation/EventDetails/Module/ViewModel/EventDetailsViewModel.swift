//
//  EventViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

class EventDetailsViewModel: ObservableObject {
    
    enum State {
        
        case edit
        case owner
        case member
        
        var isEditMode: Bool {
            self == .edit
        }
    }
    
    private(set) var event: Event
    
    @Published var infoViewModel: EventInfoViewModel
    @Published var statusViewModel: EventStatusViewModel
    @Published var members: [EventDetailsMemberViewModel]
    
    @Published var modeState: State
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    init(with event: Event) {
        self.event = event
        self.infoViewModel = EventInfoViewModel(with: event)
        self.statusViewModel = EventStatusViewModel(with: event)
        self.members = event.members
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isOwner == true && $1.isOwner != true})
            .map({ EventDetailsMemberViewModel(with: $0, event: event) })
        self.modeState = event.me.isOwner == true ? .owner : .member
    }
}


extension EventDetailsViewModel: EventDetailsViewInput {
    
    func update(with event: Event) {
        self.event = event
        self.infoViewModel = EventInfoViewModel(with: event)
        self.statusViewModel = EventStatusViewModel(with: event)
        self.members = event.members
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isOwner == true && $1.isOwner != true})
            .map({ EventDetailsMemberViewModel(with: $0, event: event) })
    }
    
    func changeEditMode() {
        generator.prepare()
        switch modeState {
        case .member, .owner:
            modeState = .edit
        case .edit:
            modeState = event.me.isOwner == true ? .owner : .member
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.generator.impactOccurred()
        }
    }
    
    func updateStatus(_ status: User.Status) {
        event.me.status = status
        statusViewModel = EventStatusViewModel(with: event)
    }
    
    func updateGame(_ game: Game) {
        event.game = game
        self.infoViewModel = EventInfoViewModel(with: event)
    }
    
    func updateDate(_ date: Date) {
        event.date = date
        self.infoViewModel = EventInfoViewModel(with: event)
    }
    
    func updateMembers(_ members: [User]) {
        event.members = members
        self.members = event.members
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isOwner == true && $1.isOwner != true})
            .map({ EventDetailsMemberViewModel(with: $0, event: event) })
    }
    
    func takeOwnerRulesToMemberAtIndex(_ index: Int) {
        event.members[index].isOwner = true
        event.me.isOwner = false
        modeState = .member
        self.members = event.members
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isOwner == true && $1.isOwner != true})
            .map({ EventDetailsMemberViewModel(with: $0, event: event) })
    }
}
