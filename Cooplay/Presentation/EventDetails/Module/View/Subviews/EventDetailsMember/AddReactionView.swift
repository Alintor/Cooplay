//
//  AddReactionView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AddReactionView: View {
    
    weak var output: EventDetailsViewOutput?
    let member: User
    
    private let reactionMenuHandler: ReactionContextMenuHandler
    
    init(
        output: EventDetailsViewOutput?,
        member: User,
        reactionContextViewHandler: ReactionContextViewHandler?
    ) {
        self.output = output
        self.member = member
        reactionMenuHandler = ReactionContextMenuHandler(viewCornerType: .circle, contextViewHandler: reactionContextViewHandler)
    }
    
    var body: some View {
        Image(R.image.commonReaction.name)
            .foregroundColor(Color(R.color.textSecondary.name))
            .frame(width: 24, height: 24, alignment: .center)
            .padding(EdgeInsets(top: 3, leading: 7, bottom: 3, trailing: 7))
            .background(Color(R.color.block.name))
            .cornerRadius(20)
            .background(GeometryGetter(delegate: reactionMenuHandler))
            .onTapGesture {
                reactionMenuHandler.takeSnaphot()
                output?.reactionTapped(for: member, delegate: reactionMenuHandler)
            }
    }
}
