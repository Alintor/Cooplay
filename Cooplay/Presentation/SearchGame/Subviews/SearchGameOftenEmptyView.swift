//
//  SearchGameEmptyView.swift
//  Cooplay
//
//  Created by Alexandr on 11.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchGameOftenEmptyView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(.searchEmptyOftenGames)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            Text(Localizable.searchGameEmptySateTitle())
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
            Text(Localizable.searchGameEmptySateDescription())
                .font(.system(size: 13))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            Spacer()
        }
        .padding(.horizontal, 52)
    }
}

