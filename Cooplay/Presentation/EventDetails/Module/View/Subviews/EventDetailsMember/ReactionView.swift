//
//  ReactionView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionView: View {
    
    let viewModel: ReactionViewModel
    weak var output: EventDetailsViewOutput?
    let member: User
    
    private let reactionMenuHandler: ReactionContextMenuHandler
    
    init(
        viewModel: ReactionViewModel,
        output: EventDetailsViewOutput?,
        member: User,
        reactionContextViewHandler: ReactionContextViewHandler?
    ) {
        self.viewModel = viewModel
        self.output = output
        self.member = member
        reactionMenuHandler = ReactionContextMenuHandler(viewCornerType: .circle, contextViewHandler: reactionContextViewHandler)
    }
    
    var body: some View {
        
        HStack {
            AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: 20)
                .frame(width: 20, height: 20, alignment: .center)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: -3))
            Text(viewModel.value)
                .font(.system(size: 16))
                .padding(.trailing, 5)
                .animation(.easeInOut(duration: 0.2))
                .transition(.scale.combined(with: .opacity))
                .id("ReactionView" + viewModel.value)
        }
        .background(Color(viewModel.isOwner ? R.color.actionDisabled.name : R.color.block.name))
        .cornerRadius(20)
        .addBorder(Color(R.color.actionAccent.name), width: viewModel.isOwner ? 2 : 0, cornerRadius: 20)
        .background(GeometryGetter(delegate: reactionMenuHandler))
        .onTapGesture {
            guard viewModel.isOwner else { return }
            reactionMenuHandler.takeSnaphot()
            output?.reactionTapped(for: member, delegate: reactionMenuHandler)
        }
    }
}
