//
//  NewEventMemberCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 07/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct NewEventMemberViewModel: Equatable {
    
    var name: String
    var avatarViewModel: AvatarViewModel
    var isSelected: Bool
    var isBlocked: Bool
    
    let model: User
    
    init(model: User, isSelected: Bool, isBlocked: Bool) {
        self.model = model
        self.isSelected = isSelected
        self.isBlocked = isBlocked
        name = model.name
        avatarViewModel = AvatarViewModel(with: model)
    }
    
    init(model: User, isSelected: Bool) {
        self.init(model: model, isSelected: isSelected, isBlocked: false)
    }
    
    static func == (lhs: NewEventMemberViewModel, rhs: NewEventMemberViewModel) -> Bool {
        lhs.model == rhs.model && lhs.isSelected == rhs.isSelected
    }
    
}
