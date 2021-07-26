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
        
        static let maxMembersCount = GlobalConstant.isSmallScreen ? 2 : 4
    }
    
    var title: String
    var date: String
    var imagePath: String?
    var statusTitle: String?
    var lateTime: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var members: [AvatarViewModel]
    var otherCount: Int?
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    
    let model: Event
    
    init(with model: Event, statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?) {
        self.model = model
        self.statusAction = statusAction
        title = model.game.name
        date = model.date.displayString
        imagePath = model.game.coverPath
        lateTime = model.me.status?.detailsString
        statusTitle = model.me.status?.title(isShort: true, event: model)
        statusIcon = model.me.status?.icon(isSmall: true)
        statusColor = model.me.status?.color
        // TODO: Sort members
        let memberViewModels = model.members.sorted(by: { $0.name < $1.name }).map { AvatarViewModel(with: $0) }
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

extension EventCellViewModel: Equatable {
    
    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        return lhs.model == rhs.model
    }
}
