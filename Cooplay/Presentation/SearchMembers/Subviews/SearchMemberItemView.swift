//
//  SearchMemberItemView.swift
//  Cooplay
//
//  Created by Alexandr on 31.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMemberItemView: View {
    
    let viewModel: NewEventMemberViewModel
    let blockedOpacity = 0.5
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: 32)
                    .frame(width: 32, height: 32, alignment: .center)
                    .opacity(viewModel.isBlocked ? blockedOpacity : 1)
                Text(viewModel.name)
                    .font(.system(size: 17))
                    .foregroundStyle(Color(.textSecondary))
                    .opacity(viewModel.isBlocked ? blockedOpacity : 1)
                Spacer()
                selectionMark
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
    
    var selectionMark: some View {
        ZStack {
            if viewModel.isSelected {
                ZStack {
                    Circle()
                        .foregroundStyle(Color(.actionAccent))
                        .frame(width: 24, height: 24, alignment: .center)
                        .opacity(viewModel.isBlocked ? blockedOpacity : 1)
                    Image(.statusNormalAccepted)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(.background))
                        .frame(width: 24, height: 24, alignment: .center)
                }
                .transition(.scale(scale: 0.2).combined(with: .opacity))
            } else {
                ZStack {
                    Circle().fill(Color(.background))
                        .frame(width: 24, height: 24)
                    Circle().fill(Color(.background))
                        .frame(width: 22, height: 22)
                        .addBorder(Color(.textSecondary), width: 1, cornerRadius: 24)
                }
                .padding(.bottom, -2)
                .padding(.trailing, -2)
            }
        }
    }
}
