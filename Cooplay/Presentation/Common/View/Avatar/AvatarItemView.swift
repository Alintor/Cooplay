//
//  AvatarItemView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Kingfisher

struct AvatarItemView: View {
    
    let viewModel: AvatarViewModel
    let diameter: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(viewModel.backgroundColor))
            Text(viewModel.firstNameLetter)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .font(.system(size: diameter / 2))
            if let path = viewModel.avatarPath {
                KFImage(URL(string: path), options: nil)
                    .resizable()
                    .cornerRadius(diameter / 2)
            }
        }
    }
}
