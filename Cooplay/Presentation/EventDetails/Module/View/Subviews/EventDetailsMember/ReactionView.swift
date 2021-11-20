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
    private let isOwner: Bool
    
    init(
        viewModel: ReactionViewModel,
        output: EventDetailsViewOutput?,
        member: User,
        reactionContextViewHandler: ReactionContextViewHandler?,
        isOwner: Bool = false
    ) {
        self.viewModel = viewModel
        self.output = output
        self.member = member
        self.isOwner = isOwner
        reactionMenuHandler = ReactionContextMenuHandler(viewCornerType: .circle, contextViewHandler: reactionContextViewHandler)
    }
    
    var body: some View {
        
        HStack {
            AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: isOwner ? 26 : 20)
                .frame(width: isOwner ? 26 : 20, height: isOwner ? 26 : 20, alignment: .center)
                .padding(EdgeInsets(
                    top: isOwner ? 7 : 5,
                    leading: isOwner ? 7 : 5,
                    bottom: isOwner ? 7 : 5,
                    trailing: -3
                ))
            Text(viewModel.value)
                .font(.system(size: isOwner ? 24 : 16))
                .padding(.trailing, isOwner ? 7 : 5)
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
