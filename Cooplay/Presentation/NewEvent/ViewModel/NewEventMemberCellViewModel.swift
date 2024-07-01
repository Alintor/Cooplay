//
//  NewEventMemberCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 07/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct NewEventMemberCellViewModel: NewEventCellViewModel, Equatable {
    
    var name: String
    var avatarViewModel: AvatarViewModel
    var isSelected: Bool
    var isBlocked: Bool
    var prevState: Bool?
    var selectAction: ((_ isSelected: Bool) -> Void)?
    
    let model: User
    
    init(model: User, isSelected: Bool, isBlocked: Bool, selectAction: ((_ isSelected: Bool) -> Void)?) {
        self.model = model
        self.selectAction = selectAction
        self.isSelected = isSelected
        self.isBlocked = isBlocked
        name = model.name
        avatarViewModel = AvatarViewModel(with: model)
    }
    
    init(model: User, isSelected: Bool, selectAction: ((Bool) -> Void)?) {
        self.init(model: model, isSelected: isSelected, isBlocked: false, selectAction: selectAction)
    }
    
    static func == (lhs: NewEventMemberCellViewModel, rhs: NewEventMemberCellViewModel) -> Bool {
        lhs.model == rhs.model && lhs.isSelected == rhs.isSelected
    }
    
}
