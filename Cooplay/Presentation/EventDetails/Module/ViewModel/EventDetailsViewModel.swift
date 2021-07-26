//
//  EventViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 15/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct EventDetailsViewModel {
    
    var title: String
    var date: String
    var coverPath: String?
    var statusTitle: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var avatarViewModel: AvatarViewModel
    var showGradient: BooleanLiteralType
    
    init(with model: Event) {
        title = model.game.name
        date = model.date.displayString
        coverPath = model.game.coverPath
        statusIcon = model.me.status?.icon()
        statusColor = model.me.status?.color
        statusTitle = model.me.status?.title()
        avatarViewModel = AvatarViewModel(with: model.me)
        showGradient = model.isActive
    }
}
