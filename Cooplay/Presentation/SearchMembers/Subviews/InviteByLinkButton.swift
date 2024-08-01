//
//  InviteByLinkButton.swift
//  Cooplay
//
//  Created by Alexandr on 29.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct InviteByLinkButton: View {
    
    let action: (() -> Void)?
    
    var body: some View {
        HStack {
            Image(.commonLink)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color(.textSecondary))
            Text(Localizable.searchMembersInviteByLinkTitle())
                .font(.system(size: 17))
                .foregroundStyle(Color(.textPrimary))
        }
        .padding(.leading, 12)
        .padding(.trailing, 16)
        .padding(.vertical, 8)
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .onTapGesture { action?() }
    }
}
