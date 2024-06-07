//
//  EventStatusViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftDate

struct EventStatusViewModel {
    
    var title: String
    var icon: Image
    var color: Color
    var avatarViewModel: AvatarViewModel
    var detailsViewModel: StatusDetailsViewModel?
    
    init(with event: Event) {
        icon = event.me.status.icon
        color = event.me.status.color
        switch event.me.status {
        case .suggestDate(let minutes):
            let newDate = event.date + minutes.minutes
            detailsViewModel = StatusDetailsViewModel(with: newDate, eventDate: event.date)
        default:
            break
        }
        if event.needConfirm {
            title = Localizable.statusConfirmation()
            detailsViewModel = nil
        } else {
            title = event.me.status.title
        }
        avatarViewModel = AvatarViewModel(with: event.me)
    }
}
