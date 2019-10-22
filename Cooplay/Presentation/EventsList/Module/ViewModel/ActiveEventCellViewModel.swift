//
//  ActiveEventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct ActiveEventCellViewModel {
    
    private enum Constant {
        
        static let maxMembersCount = 4
    }
    
    var title: String
    var date: String
    var imagePath: String
    var statusTitle: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var members: [MemberStatusViewModel]
    var otherCount: Int?
    
    let model: Event
    
    init(with model: Event) {
        self.model = model
        title = model.game.name
        date = model.date.displayString
        imagePath = model.game.imagePath
        if let status = model.me.status {
            var statusTitle = NSLocalizedString("common.statuses.\(status.rawValue).full", comment: "")
            statusIcon = UIImage(named: "status.\(status.rawValue)")
            statusColor = UIColor(named: "status.\(status.rawValue)")
            if let lateness = model.me.lateness {
                statusTitle = "\(statusTitle) \(R.string.localizable.commonLateTime(lateness))"
            }
            self.statusTitle = statusTitle
        }
        // TODO: Sort members
        let memberViewModels = model.members.map { MemberStatusViewModel(with: $0) }
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
