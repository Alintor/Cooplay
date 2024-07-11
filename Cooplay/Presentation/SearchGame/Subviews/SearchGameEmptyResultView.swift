//
//  SearchGameEmptyResultView.swift
//  Cooplay
//
//  Created by Alexandr on 11.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchGameEmptyResultView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(.commonGameCover)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 90)
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
            Text(Localizable.searchGameEmptyResultsTitle())
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .padding(.top, 16)
            Text(Localizable.searchGameEmptyResultsDescription())
                .font(.system(size: 13))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
                .padding(.top, 4)
            Spacer()
        }
        .padding(.horizontal, 52)
    }
}
