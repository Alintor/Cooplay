//
//  EditProfileViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

final class EditProfileViewModel: ObservableObject {
    
    @Published var name: String
    @Published var image: UIImage?
    @Published var avatarPath: String?
    var nameFirstLetter: String {
        name.firstBigLetter
    }
    let avatarBackgroundColor: UIColor
    private let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
        name = profile.name
        avatarPath = profile.avatarPath
        avatarBackgroundColor = UIColor.avatarBackgroundColor(profile.id)
    }
}

extension EditProfileViewModel: EditProfileViewInput {

}
