//
//  SearchGameSceletonView.swift
//  Cooplay
//
//  Created by Alexandr on 11.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchGameSkeletonView: View {
    
    let title: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 12)
                Rectangle()
                    .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
                    .padding(.leading, 16)
                    .frame(height: 1 / UIScreen.main.scale)
                ForEach(0...7, id: \.self) { index in
                    skeletonItem(isSort: index % 2 == 0)
                }
            }
        }
        .disabled(true)
    }
    
    func skeletonItem(isSort: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Rectangle().fill(Color(.block))
                    .frame(width: 52, height: 66, alignment: .center)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
                Rectangle().fill(Color(.block))
                    .frame(width: isSort ? 160 : 200, height: 24, alignment: .center)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            separator
        }
        .shimmer()
    }
    
    var separator: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
            .padding(.leading, 80)
            .frame(height: 1 / UIScreen.main.scale)
    }
}
