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
    weak var output: EventDetailsViewOutput?
    let reactionContextViewHandler: ReactionContextViewHandler?
    let member: User
    
    let needAddButton: Bool
    
    init(
        reactions: [ReactionViewModel],
        output: EventDetailsViewOutput?,
        reactionContextViewHandler: ReactionContextViewHandler?,
        member: User
    ) {
        self.reactions = reactions
        self.output = output
        self.reactionContextViewHandler = reactionContextViewHandler
        self.member = member
        needAddButton = !reactions.contains(where: { $0.isOwner })
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                if needAddButton {
                    AddReactionView(output: output, member: member, reactionContextViewHandler: reactionContextViewHandler)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        .animation(.easeInOut(duration: 0.2))
                        .transition(.scale.combined(with: .opacity))
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                }
                
                ForEach(self.reactions, id: \.user.name) { reaction in
                    ReactionView(viewModel: reaction, output: output, member: member, reactionContextViewHandler: reactionContextViewHandler)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        .animation(.easeInOut(duration: 0.2))
                        .transition(.scale.combined(with: .opacity))
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                }
            }
            .padding(.horizontal, 10)
        }
        .rotationEffect(Angle.degrees(180))
        .scaleEffect(x: 1, y: -1, anchor: .center)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(R.color.background.name).opacity(0),
                        Color(R.color.background.name),
                        Color(R.color.background.name)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
