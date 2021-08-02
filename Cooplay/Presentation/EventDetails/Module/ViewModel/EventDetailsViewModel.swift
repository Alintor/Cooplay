//
//  EventViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 15/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftDate

struct EventDetailsViewModel {
    
    var title: String
    var date: String
    var coverPath: String?
    var statusTitle: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var avatarViewModel: AvatarViewModel
    var statusDetailsViewModel: StatusDetailsViewModel?
    var showGradient: BooleanLiteralType
    
    init(with model: Event) {
        title = model.game.name
        date = model.date.displayString
        coverPath = model.game.coverPath
        statusIcon = model.me.status?.icon()
        statusColor = model.me.status?.color
        switch model.me.status {
        case .suggestDate(let minutes):
            let newDate = model.date + minutes.minutes
            statusDetailsViewModel = StatusDetailsViewModel(with: newDate)
        default:
            break
        }
        if model.needConfirm {
            statusTitle = R.string.localizable.statusConfirmation()
            statusDetailsViewModel = nil
        } else {
            statusTitle = model.me.status?.title(event: model)
        }
        avatarViewModel = AvatarViewModel(with: model.me)
        switch model.me.status {
        case .unknown:
            showGradient = false
        default:
            showGradient = model.isActive
        }
    }
}
