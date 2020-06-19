//
//  AvatarViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

class AvatarViewModel {
    
    let model: User
    
    var firstNameLetter: String
    var backgroundColor: UIColor
    var avatarPath: String?
    
    init(with model: User) {
        self.model = model
        firstNameLetter = String(model.name?.prefix(1) ?? "").uppercased()
        backgroundColor = UIColor.avatarBackgroundColor(model.id)
        avatarPath = model.avatarPath
    }
}
