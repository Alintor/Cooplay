//
//  NewEventSceletonGamesView.swift
//  Cooplay
//
//  Created by Alexandr on 28.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventSkeletonGamesView: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0...4, id: \.self) { _ in
                    Rectangle().fill(Color(.block))
                        .frame(width: 70, height: 90)
                        .clipShape(.rect(cornerRadius: 12, style: .continuous))
                }
            }
            .padding(.bottom, 2)
            .padding(.horizontal, 24)
        }
        .shimmer()
        .disabled(true)
    }
}
