//
//  ProfileState.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import Combine

class ProfileState: ObservableObject {
    
    @Published var profile: Profile
    let settings: [ProfileSettingsItem.Section: [ProfileSettingsItem]]
    
    init(profile: Profile) {
        self.profile = profile
        self.settings = ProfileSettingsItem.items
    }
    
    func update(with profile: Profile) {
        self.profile = profile
    }
}
