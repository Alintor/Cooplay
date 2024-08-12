//
//  SearchGameItemView.swift
//  Cooplay
//
//  Created by Alexandr on 11.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct SearchGameItemView: View {
    
    let viewModel: NewEventGameViewModel
    let selectedOpacity = 0.5
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                gameCover
                    .opacity(viewModel.isSelected ? selectedOpacity : 1)
                Text(viewModel.model.name)
                    .font(.system(size: 18))
                    .foregroundStyle(Color(.textSecondary))
                    .opacity(viewModel.isSelected ? selectedOpacity : 1)
                Spacer()
                if viewModel.isSelected {
                    selectionMark
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            separator
        }
    }
    
    var separator: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
            .padding(.leading, 80)
            .frame(height: 1 / UIScreen.main.scale)
    }
    
    var gameCover: some View {
        ZStack {
            if let path = viewModel.coverPath {
                KFImage(URL(string: path))
                    .placeholder({
                        Image(.commonGameCover)
                    })
                    .resizable()
                    .frame(width: 52, height: 66, alignment: .center)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
            } else {
                Image(.commonGameCover)
                    .resizable()
                    .frame(width: 52, height: 66, alignment: .center)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
            }
        }
    }
    
    var selectionMark: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(.actionAccent))
                .frame(width: 24, height: 24, alignment: .center)
                .opacity(viewModel.isSelected ? selectedOpacity : 1)
            Image(.statusNormalAccepted)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(.background))
                .frame(width: 24, height: 24, alignment: .center)
        }
    }
}
