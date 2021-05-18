//
//  SearchMembersCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 20/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct SearchMembersCellViewModel {
    
    let avatarViewModel: AvatarViewModel
    let name: String
    var isSelected: Bool
    let isBlocked: Bool
    let selectionHandler: ((_ isSelected: Bool) -> Void)?
    let model: User
    
    init(with model: User, isSelected: Bool, isBlocked: Bool, selectionHandler: ((_ isSelected: Bool) -> Void)?) {
        self.model = model
        self.selectionHandler = selectionHandler
        self.isSelected = isSelected
        self.isBlocked = isBlocked
        avatarViewModel = AvatarViewModel(with: model)
        name = model.name
    }
}
