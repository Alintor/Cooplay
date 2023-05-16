//
//  ActiveEventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftDate

struct ActiveEventCellViewModel {
    
    private enum Constant {
        
        static let maxMembersCount = 4
    }
    
    var title: String
    var date: String
    var coverPath: String?
    var previewPath: String?
    var statusTitle: String?
    var statusIcon: UIImage?
    var statusColor: UIColor?
    var members: [MemberStatusViewModel]
    var otherCount: Int?
    var avatarViewModel: AvatarViewModel
    var statusDetailsViewModel: StatusDetailsViewModel?
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    
    let model: Event
    
    init(with model: Event, statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?) {
        self.model = model
        self.statusAction = statusAction
        title = model.game.name
        date = model.date.displayString
        coverPath = model.game.coverPath
        previewPath = model.game.previewImagePath
        statusIcon = model.me.status.icon()
        statusColor = model.me.status.color
        avatarViewModel = AvatarViewModel(with: model.me)
        switch model.me.status {
        case .suggestDate(let minutes):
            let newDate = model.date + minutes.minutes
            statusDetailsViewModel = StatusDetailsViewModel(with: newDate, eventDate: model.date)
        default:
            break
        }
        if model.needConfirm {
            statusTitle = R.string.localizable.statusConfirmation()
            statusDetailsViewModel = nil
        } else {
            statusTitle = model.me.status.title(event: model)
        }
        
        let memberViewModels = model.members.sorted(by: { $0.name < $1.name }).map { MemberStatusViewModel(with: $0) }
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

extension ActiveEventCellViewModel: Equatable {
    
    static func == (lhs: ActiveEventCellViewModel, rhs: ActiveEventCellViewModel) -> Bool {
        return lhs.model == rhs.model
    }
}
