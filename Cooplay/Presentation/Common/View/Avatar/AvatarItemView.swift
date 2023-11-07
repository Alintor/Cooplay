//
//  AvatarItemView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct AvatarItemView: View {
    
    let viewModel: AvatarViewModel
    let diameter: CGFloat
    
    var body: some View {
        ZStack {
            if let path = viewModel.avatarPath {
                KFImage(URL(string: path), options: nil)
                    .placeholder({
                        defaultAvatar
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .cornerRadius(diameter / 2)
                    .clipped()
            } else {
                defaultAvatar
            }
        }
    }
    
    var defaultAvatar: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(viewModel.backgroundColor))
            Text(viewModel.firstNameLetter)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .font(.system(size: diameter / 2))
        }
    }
}
