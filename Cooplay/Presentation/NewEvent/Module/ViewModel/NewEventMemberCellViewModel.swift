//
//  NewEventMemberCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 07/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct NewEventMemberCellViewModel: NewEventCellViewModel {
    
    var name: String
    var avatarViewModel: AvatarViewModel
    var isSelected: Bool
    var prevState: Bool?
    var selectAction: ((_ isSelected: Bool) -> Void)?
    
    let model: User
    
    init(model: User, isSelected: Bool, selectAction: ((_ isSelected: Bool) -> Void)?) {
        self.model = model
        self.selectAction = selectAction
        self.isSelected = isSelected
        name = model.name
        avatarViewModel = AvatarViewModel(with: model)
    }
    
}
