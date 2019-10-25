//
//  EventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct EventCellViewModel {
    
    private enum Constant {
        
        static let maxMembersCount = 4
    }
    
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
            statusIcon = UIImage(named: "status.small.\(status.rawValue)")
            statusColor = UIColor(named: "status.\(status.rawValue)")
        }
        // TODO: Sort members
        let memberViewModels = model.members.map { AvatarViewModel(with: $0) }
        let otherCount = memberViewModels.count - Constant.maxMembersCount
        if otherCount > 1 {
            members = Array(memberViewModels.prefix(Constant.maxMembersCount))
            self.otherCount = otherCount
        } else {
            members = memberViewModels
            self.otherCount = nil
        }
    }
}
