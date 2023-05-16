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
                        .cornerRadius(54)
                }
            }.frame(width: 108, height: 108, alignment: .center)
            Text("Изменить")
                .fontWeight(.medium)
                .font(.system(size: 12))
                .foregroundColor(Color(R.color.actionAccent.name))
        }
    }
}
