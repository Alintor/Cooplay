//
//  EventDetailsMemberViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftDate

struct EventDetailsMemberViewModel {
    
    let member: User
    
    var name: String
    var status: String
    var statusColor: Color
    var statusIcon: Image
    var avatarViewModel: AvatarViewModel
    var isOwner: Bool
    var reactions: [ReactionViewModel]
    var detailsViewModel: StatusDetailsViewModel?
    
    
    init(with member: User, event: Event) {
        self.member = member
        name = member.name
        status = member.status.title
        switch member.status {
        case .suggestDate(let minutes):
            let newDate = event.date + minutes.minutes
            detailsViewModel = StatusDetailsViewModel(with: newDate, eventDate: event.date)
        default:
            break
        }
        statusColor = member.status.color
        statusIcon = member.status.icon
        avatarViewModel = AvatarViewModel(with: member)
        isOwner = member.isOwner == true
        reactions = member.reactions.map({ ReactionViewModel.build(reactions: $0, event: event) }) ?? []
    }
}
