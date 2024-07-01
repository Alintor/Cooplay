//
//  NewEventSkeletonMembersView.swift
//  Cooplay
//
//  Created by Alexandr on 01.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventSkeletonMembersView: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0...5, id: \.self) { _ in
                    memberItem
                }
            }
            .padding(.horizontal, 24)
        }
        .shimmer()
        .disabled(true)
    }
    
    var memberItem: some View {
        VStack(spacing: 8) {
            Circle().fill(Color(.block))
                .frame(width: 52, height: 52)
            Rectangle().fill(Color(.block))
                .frame(width: 52, height: 12)
                .clipShape(.rect(cornerRadius: 6, style: .continuous))
        }
    }
}
