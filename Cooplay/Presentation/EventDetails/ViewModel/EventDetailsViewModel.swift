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
    @Published var reactions: [ReactionViewModel]
    
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
        self.reactions = event.me.reactions.map({ ReactionViewModel.build(reactions: $0, event: event) }) ?? []
    }
}


extension EventDetailsViewModel: EventDetailsViewInput {
    
    func update(with event: Event) {
        guard !self.event.isEqual(event) else { return }
        
        self.event = event
        self.infoViewModel = EventInfoViewModel(with: event)
        self.statusViewModel = EventStatusViewModel(with: event)
        self.members = event.members
            .sorted(by: { $0.name < $1.name })
            .sorted(by: { $0.isOwner == true && $1.isOwner != true})
            .map({ EventDetailsMemberViewModel(with: $0, event: event) })
        self.reactions = event.me.reactions.map({ ReactionViewModel.build(reactions: $0, event: event) }) ?? []
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
    
    func currentReaction(to member: User) -> Reaction? {
        if member == event.me {
            return event.me.reactions?[event.me.id]
        }
        guard let index = event.members.firstIndex(of: member) else { return nil }
        return event.members[index].reactions?[event.me.id]
    }
    
    func addReaction(_ reaction: Reaction?, to member: User) {
        if member == event.me {
            var reactions = event.me.reactions ?? [:]
            reactions[event.me.id] = reaction
            event.me.reactions = reactions
            self.reactions = event.me.reactions.map({ ReactionViewModel.build(reactions: $0, event: event) }) ?? []
        }
        if let index = event.members.firstIndex(of: member) {
            var reactions = event.members[index].reactions ?? [:]
            reactions[event.me.id] = reaction
            event.members[index].reactions = reactions
            updateMembers(event.members)
        }
        
    }
    
    func getActualMemberInfo(_ member: User) -> User? {
        if member == event.me {
            return event.me
        }
        if let index = event.members.firstIndex(of: member) {
            return event.members[index]
        }
        return nil
    }
}
