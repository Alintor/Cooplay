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
    
    init(viewModel: EventDetailsMemberViewModel, output: EventDetailsViewOutput?) {
        self.viewModel = viewModel
        self.output = output
        self.contextMenuHandler = ContextMenuHandler(viewCornerType: .rounded(value: 12))
        self.reactionContextViewHandler = ReactionContextViewHandler(viewCornerType: .rounded(value: 12))
    }
    
    let contextMenuHandler: ContextMenuHandler
    let generator = UIImpactFeedbackGenerator(style: .medium)
    @ObservedObject var reactionContextViewHandler: ReactionContextViewHandler
    
    @State var isMemberInfoViewHidden: Bool = false
    
//    func configureHandler() {
//        reactionContextViewHandler.hideView = { hide in
//            self.isMemberInfoViewHidden = hide
//        }
//    }
    
    var body: some View {
        //configureHandler()
        VStack(spacing: 0) {
            EventDetailsMemberInfoView(viewModel: viewModel)
                .background(GeometryGetter(delegate: contextMenuHandler))
                .background(GeometryGetter(delegate: reactionContextViewHandler))
                .opacity(isMemberInfoViewHidden ? 0 : 1)
                .animation(nil)
                .gesture(TapGesture(count: 2).onEnded({
                    generator.impactOccurred()
                    output?.didDoubleTapItem(viewModel.member)
                }).exclusively(before: TapGesture().onEnded({
                    contextMenuHandler.takeSnaphot()
                    output?.itemSelected(viewModel.member, delegate: contextMenuHandler)
                })))
            ReactionsListView(
                reactions: viewModel.reactions,
                output: output,
                reactionContextViewHandler: reactionContextViewHandler,
                member: viewModel.member
            )
        }
        .onReceive(reactionContextViewHandler.$isViewHidden) { isViewHidden in
            isMemberInfoViewHidden = isViewHidden
        }
    }
}
