//
//  ProfileAvatar.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct ProfileAvatar: View {
    
    let viewModel: AvatarViewModel
    
    init(profile: Profile) {
        viewModel = AvatarViewModel(with: profile.user)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(viewModel.backgroundColor))
            Text(viewModel.firstNameLetter)
                .fontWeight(.semibold)
                .font(.system(size: 48))
            if let path = viewModel.avatarPath {
                KFImage(URL(string: path), options: nil)
                    .resizable()
                    .cornerRadius(54)
            }
        }
    }
}
