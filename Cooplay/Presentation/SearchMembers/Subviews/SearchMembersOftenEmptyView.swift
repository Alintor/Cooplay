//
//  SearchMembersOftenEmptyView.swift
//  Cooplay
//
//  Created by Alexandr on 29.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMembersOftenEmptyView: View {
    
    let tapInviteByLinkHandler: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(.searchEmptyOftenMembers)
                .resizable()
                .scaledToFit()
                .frame(height: 90)
            Text(Localizable.searchMembersEmptySateTitle())
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .padding(.top, 16)
            Text(Localizable.searchMembersEmptySateDescription())
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
