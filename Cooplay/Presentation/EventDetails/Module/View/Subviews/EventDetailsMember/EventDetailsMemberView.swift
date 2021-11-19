//
//  EventDetailsMemberView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsMemberView: View {
    
    var viewModel: EventDetailsMemberViewModel
    weak var output: EventDetailsViewOutput?
    
    let contextMenuHandler = ContextMenuHandler(viewCornerType: .rounded(value: 12))
    let reactionContextViewHandler = ReactionContextViewHandler(viewCornerType: .rounded(value: 12))
    
    @State var isMemberInfoViewHidden: Bool = false
    
    func configureHandler() {
        reactionContextViewHandler.hideView = { hide in
            self.isMemberInfoViewHidden = hide
        }
    }
    
    var body: some View {
        configureHandler()
        return VStack(spacing: 0) {
            EventDetailsMemberInfoView(viewModel: viewModel)
                .background(GeometryGetter(delegate: contextMenuHandler))
                .background(GeometryGetter(delegate: reactionContextViewHandler))
                .opacity(isMemberInfoViewHidden ? 0 : 1)
                .animation(nil)
                .onTapGesture {
                    contextMenuHandler.takeSnaphot()
                    output?.itemSelected(viewModel.member, delegate: contextMenuHandler)
                }
            ReactionsListView(
                reactions: viewModel.reactions,
                output: output,
                reactionContextViewHandler: reactionContextViewHandler,
                member: viewModel.member
            )
        }
    }
}
