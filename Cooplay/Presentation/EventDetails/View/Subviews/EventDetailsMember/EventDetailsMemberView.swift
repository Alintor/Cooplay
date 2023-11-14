//
//  EventDetailsMemberView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsMemberView: View {
    
    @EnvironmentObject var state: EventDetailsState
    
    var viewModel: EventDetailsMemberViewModel
    
    @State var isMemberInfoViewHidden: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            EventDetailsMemberInfoView(viewModel: viewModel)
                .opacity(isMemberInfoViewHidden ? 0 : 1)
                .animation(nil)
                .gesture(TapGesture(count: 2).onEnded({
                    Haptic.play(style: .medium)
                    state.sendMainReaction(to: viewModel.member)
                }).exclusively(before: TapGesture().onEnded({
                    //output?.itemSelected(viewModel.member, delegate: contextMenuHandler)
                })))
            ReactionsListView(
                reactions: viewModel.reactions,
                member: viewModel.member
            )
        }
    }
}
