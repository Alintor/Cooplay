//
//  SearchMembersSkeletonView.swift
//  Cooplay
//
//  Created by Alexandr on 31.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMembersSkeletonView: View {
    
    let title: String
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                InviteByLinkButton(action: nil)
                    .padding(.top, 16)
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
                ForEach(0...15, id: \.self) { index in
                    skeletonItem(isSort: index % 2 == 0)
                }
            }
        }
        .disabled(true)
    }
    
    func skeletonItem(isSort: Bool) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Circle().fill(Color(.block))
                    .frame(width: 32, height: 32, alignment: .center)
                Rectangle().fill(Color(.block))
                    .frame(width: isSort ? 120 : 160, height: 24, alignment: .center)
                    .clipShape(.rect(cornerRadius: 8, style: .continuous))
                Spacer()
                Circle().fill(Color(.block))
                    .frame(width: 24, height: 24, alignment: .center)
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
