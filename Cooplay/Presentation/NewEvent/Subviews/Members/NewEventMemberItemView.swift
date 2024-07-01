//
//  NewEventMemberItemView.swift
//  Cooplay
//
//  Created by Alexandr on 01.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventMemberItemView: View {
    
    let model: NewEventMemberCellViewModel
    
    var body: some View {
        VStack {
            avatarView
                .frame(width: 52)
            Text(model.name)
                .foregroundStyle(Color(model.isSelected ? .textPrimary : .textSecondary))
                .font(.system(size: 13))
                .lineLimit(1)
                .frame(width: 66)
        }
        //.frame(width: 56)
    }
    
    var avatarView: some View {
        ZStack {
            AvatarItemView(viewModel: model.avatarViewModel, diameter: model.isSelected ? 44 : 52)
                .padding(model.isSelected ? 4 : 0)
                .addBorder(Color(.actionAccent), width: model.isSelected ? 2 : 0, cornerRadius: 100)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        ZStack {
                            Circle().fill(Color(.background))
                                .frame(width: 20, height: 20)
                            Circle().fill(Color(.background))
                                .frame(width: 16, height: 16)
                                .addBorder(Color(.textSecondary), width: 1, cornerRadius: 20)
                        }
                        .padding(.bottom, -2)
                        .padding(.trailing, -2)
                        if model.isSelected {
                            Image(.statusSmallAccepted)
                                .foregroundStyle(Color(.background))
                                .background(Color(.actionAccent))
                                .padding(2)
                                .clipShape(.rect(cornerRadius: 10, style: .circular))
                                .addBorder(Color(.background), width: 2, cornerRadius: 10)
                                .transition(.scale(scale: 0.2).combined(with: .opacity))
                                .padding(.bottom, -2)
                                .padding(.trailing, -2)
                        }
                    }
                }
            }
        }
    }
}
