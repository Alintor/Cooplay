//
//  ProfileAvatar.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileAvatar: View {
    
    let viewModel: AvatarViewModel
    
    init(user: User) {
        viewModel = AvatarViewModel(with: user)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(viewModel.backgroundColor))
            Text(viewModel.firstNameLetter)
                .fontWeight(.semibold)
                .font(.system(size: 48))
        }
    }
}
