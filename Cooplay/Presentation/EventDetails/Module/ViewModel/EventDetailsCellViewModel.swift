//
//  EventDetailsCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 16/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftDate

struct EventDetailsCellViewModel {
    
    var name: String
    var lateness: String?
    var statusColor: UIColor?
    var statusIcon: UIImage?
    var avatarViewModel: AvatarViewModel
    var isOwner: Bool
    
    let model: User
    
    init(with model: User, event: Event) {
        self.model = model
        name = model.name
        switch model.status {
        case .late:
            if let lateTime = model.status?.detailsString{
                lateness = R.string.localizable.eventDetailsCellLateness(lateTime)
            }
        case .suggestDate(let minutes):
            let newDate = event.date + minutes.minutes
            lateness = R.string.localizable.eventDetailsCellSuggestDate(newDate.displayString)
        default:
            break
        }
        statusColor = model.status?.color
        statusIcon = model.status?.icon(isSmall: false)
        avatarViewModel = AvatarViewModel(with: model)
        isOwner = model.isOwner == true
    }
}
