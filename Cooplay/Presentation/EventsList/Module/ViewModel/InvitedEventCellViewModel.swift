//
//  InvitedEventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 11/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct InvitedEventCellViewModel {
    
    private enum Constant {
        
        static let maxMembersCount = GlobalConstant.isSmallScreen ? 1 : 3
    }
    
    enum Action {
        case accept
        case details(delegate: StatusContextDelegate?)
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
    var statusAction: ((_ action: Action) -> Void)?
    
    let model: Event
    
    init(with model: Event, statusAction: ((_ action: Action) -> Void)?) {
        self.model = model
        self.statusAction = statusAction
        title = model.game.name
        date = model.date.displayString
        imagePath = model.game.coverPath
        lateTime = model.me.status?.lateTimeString
        statusTitle = model.me.status?.title(isShort: true)
        statusIcon = model.me.status?.icon(isSmall: true)
        statusColor = model.me.status?.color
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

extension InvitedEventCellViewModel: Equatable {
    
    static func == (lhs: InvitedEventCellViewModel, rhs: InvitedEventCellViewModel) -> Bool {
        return lhs.model == rhs.model
    }
}
