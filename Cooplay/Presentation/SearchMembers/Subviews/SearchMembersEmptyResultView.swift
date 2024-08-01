//
//  SearchMembersEmptyResultView.swift
//  Cooplay
//
//  Created by Alexandr on 31.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMembersEmptyResultView: View {
    
    let tapInviteByLinkHandler: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            AvatarItemView(viewModel: .init(with: .init(id: "Test", name: "?", avatarPath: nil, state: .unknown)), diameter: 64)
                .frame(width: 64, height: 64, alignment: .center)
            Text(Localizable.searchMembersEmptyResultsTitle())
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .padding(.top, 16)
            Text(Localizable.searchMembersEmptyResultsDescription())
                .font(.system(size: 13))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            InviteByLinkButton(action: tapInviteByLinkHandler)
                .padding(.top, 24)
            Spacer()
        }
        .padding(.horizontal, 52)
    }
}
