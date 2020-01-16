//
//  EventDetailsCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 16/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct EventDetailsCellViewModel {
    
    var name: String
    var lateness: String?
    var statusColor: UIColor?
    var statusIcon: UIImage?
    var avatarViewModel: AvatarViewModel
    var isOwner: Bool
    
    let model: User
    
    init(with model: User) {
        self.model = model
        name = model.name
        if let lateTime = model.status?.lateTimeString {
            lateness = R.string.localizable.eventDetailsCellLateness(lateTime)
        }
        statusColor = model.status?.color
        statusIcon = model.status?.icon(isSmall: false)
        avatarViewModel = AvatarViewModel(with: model)
        isOwner = model.isOwner == true
    }
}
