//
//  EventDetailsMemberViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

struct EventDetailsMemberViewModel {
    
    let member: User
    
    var name: String
    var status: String
    var statusColor: Color
    var statusIcon: Image?
    var avatarViewModel: AvatarViewModel
    var isOwner: Bool
    
    
    init(with member: User, event: Event) {
        self.member = member
        name = member.name
        status = member.status.title(event: event)
        statusColor = Color(member.status.color)
        statusIcon = member.status.icon(isSmall: false).flatMap({Image(uiImage: $0)})
        avatarViewModel = AvatarViewModel(with: member)
        isOwner = member.isOwner == true
    }
}
