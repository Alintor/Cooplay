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
    
    @EnvironmentObject var state: EditProfileState
    @EnvironmentObject var profileState: ProfileState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        return VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(state.avatarBackgroundColor))
                Text(state.nameFirstLetter)
                    .fontWeight(.semibold)
                    .font(.system(size: 48))
                if let path = state.avatarPath {
                    KFImage(URL(string: path), options: nil)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 108, height: 108, alignment: .center)
                        .cornerRadius(54)
                        .clipped()
                }
                if let image = state.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 108, height: 108, alignment: .center)
                        .cornerRadius(54)
                        .clipped()
                }
                
            }
            .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace.id)
            .frame(width: 108, height: 108, alignment: .center)
            Text(Localizable.editProfileChangeAvatar())
                .fontWeight(.medium)
                .font(.system(size: 12))
                .foregroundColor(Color(R.color.actionAccent.name))
        }
    }
}
