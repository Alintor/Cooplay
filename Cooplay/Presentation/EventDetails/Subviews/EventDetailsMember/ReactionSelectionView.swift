//
//  ReactionSelectionView.swift
//  Cooplay
//
//  Created by Alexandr on 14.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionSelectionView: View {
    
    let reactions: [String]
    let selectedReaction: String?
    let selectionHandler: ((_ reaction: Reaction?) -> Void)?
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(reactions, id: \.self) { item in
                reactionView(item)
                    .onTapGesture {
                        selectionHandler?(
                            selectedReaction == item ? nil : Reaction(style: .emoji, value: item)
                        )
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 56, style: .continuous))
    }
    
    func reactionView(_ reaction: String) -> some View {
        VStack(spacing: 2) {
            Text(reaction)
                .font(.system(size: 31))
            Circle()
                .frame(width: 4, height: 4)
                .foregroundStyle(Color(.textSecondary))
                .opacity(selectedReaction == reaction ? 1 : 0)
        }
    }
}

#Preview {
    ReactionSelectionView(reactions: GlobalConstant.defaultsReactions, selectedReaction: "👎", selectionHandler: nil)
}
