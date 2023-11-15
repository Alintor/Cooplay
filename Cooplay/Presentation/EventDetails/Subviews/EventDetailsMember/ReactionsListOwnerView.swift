//
//  ReactionsListOwnerView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionsListOwnerView: View {
    
    var reactions: [ReactionViewModel]
    let member: User
    
    var needAddButton: Bool {
        !reactions.contains(where: { $0.isOwner })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if needAddButton {
                    AddReactionView(
                        member: member,
                        isOwner: true
                    )
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        .animation(.easeInOut(duration: 0.2))
                        .transition(.scale.combined(with: .opacity))
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                }
                
                ForEach(self.reactions, id: \.user.name) { reaction in
                    ReactionView(
                        viewModel: reaction,
                        member: member,
                        isOwner: true
                    )
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        .animation(.easeInOut(duration: 0.2))
                        .transition(.scale.combined(with: .opacity))
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                }
            }
            .padding(.horizontal, 10)
        }
        .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}
