//
//  EditAvatarView.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct EditAvatarView: View {
    
    @ObservedObject var viewModel: EditProfileViewModel
    
    var body: some View {
        return VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(viewModel.avatarBackgroundColor))
                Text(viewModel.nameFirstLetter)
                    .fontWeight(.semibold)
                    .font(.system(size: 48))
                if let path = viewModel.avatarPath {
                    KFImage(URL(string: path), options: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 108, height: 108, alignment: .center)
                        .cornerRadius(54)
                        .clipped()
                }
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 108, height: 108, alignment: .center)
                        .cornerRadius(54)
                        .clipped()
                }
                
            }.frame(width: 108, height: 108, alignment: .center)
            Text(Localizable.editProfileChangeAvatar())
                .fontWeight(.medium)
                .font(.system(size: 12))
                .foregroundColor(Color(R.color.actionAccent.name))
        }
    }
}
