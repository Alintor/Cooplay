//
//  ProfileState.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

struct ProfileState {
    
    var user: User
    let settings: [ProfileSettingsItem.Section: [ProfileSettingsItem]]
    
    init(user: User) {
        self.user = user
        self.settings = ProfileSettingsItem.items
    }
}
