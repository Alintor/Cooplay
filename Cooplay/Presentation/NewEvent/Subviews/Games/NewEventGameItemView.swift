//
//  NewEventGameItmeView.swift
//  Cooplay
//
//  Created by Alexandr on 28.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct NewEventGameItemView: View {
    
    let model: NewEventGameCellViewModel
    
    var body: some View {
        ZStack {
            gameCover
                .padding(model.isSelected ? 4 : 2)
                .addBorder(Color(.actionAccent), width: model.isSelected ? 2 : 0, cornerRadius: 12)
            VStack {
                Spacer()
                HStack {
                    Spacer()
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
    
    var gameCover: some View {
        ZStack {
            if let path = model.coverPath {
                KFImage(URL(string: path))
                    .placeholder({
                        Image(.commonGameCover)
                    })
                    .resizable()
                    .frame(width: model.isSelected ? 66 : 70, height: model.isSelected ? 86 : 90, alignment: .center)
                    .clipShape(.rect(cornerRadius: model.isSelected ? 8 : 12, style: .continuous))
            } else {
                Image(.commonGameCover)
                    .resizable()
                    .frame(width: model.isSelected ? 66 : 70, height: model.isSelected ? 86 : 90, alignment: .center)
                    .clipShape(.rect(cornerRadius: model.isSelected ? 8 : 12, style: .continuous))
            }
        }
    }
}
