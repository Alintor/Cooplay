//
//  EventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct EventCellViewModel {
    
    var title: String
    var date: String
    var imagePath: String
    var statusTitle: String?
    var lateTime: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var members: [AvatarViewModel]
    var otherCount: Int?
    
    let model: Event
    
    init(with model: Event) {
        self.model = model
        title = model.game.name
        date = model.date.displayString
        imagePath = model.game.imagePath
        if let lateness = model.me.lateness {
            lateTime = "\(lateness)"
        }
        if let status = model.me.status {
            statusTitle = NSLocalizedString("common.statuses.\(status.rawValue)", comment: "")
            statusIcon = UIImage(named: "status.\(status.rawValue).small")
            switch status {
            case .ontime:
                statusColor = R.color.statusOntime()
            case .maybe:
                statusColor = R.color.statusMaybe()
            case .late:
                statusColor = R.color.statusLate()
            case .declined:
                statusColor = R.color.statusDeclined()
            case .unknown:
                statusColor = R.color.statusUnknown()
            }
            
        }
        // TODO: Sort members
        let memberViewModels = model.members.map { AvatarViewModel(with: $0) }
        members = memberViewModels
    }
}
