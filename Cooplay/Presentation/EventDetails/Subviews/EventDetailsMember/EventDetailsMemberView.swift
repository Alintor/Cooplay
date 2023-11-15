//
//  EventDetailsMemberView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

final class EventDetailsMemberState: ObservableObject {
    
    @Published var showContext = false
}

struct EventDetailsMemberView: View {
    
    @EnvironmentObject var eventState: EventDetailsState
    @StateObject var state = EventDetailsMemberState()
    @State var reactionsRect: CGRect = .zero
    @State var memberInfoOpacity: CGFloat = 1
    
    var viewModel: EventDetailsMemberViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            EventDetailsMemberInfoView(viewModel: viewModel)
                .animation(nil)
                .opacity(memberInfoOpacity)
                .gesture(TapGesture(count: 2).onEnded({
                    Haptic.play(style: .medium)
                    eventState.sendMainReaction(to: viewModel.member)
                }).exclusively(before: TapGesture().onEnded({
                    //output?.itemSelected(viewModel.member, delegate: contextMenuHandler)
                })))
            ReactionsListView(
                reactions: viewModel.reactions,
                member: viewModel.member
            )
            .environmentObject(state)
            .handleRect(in: .named(GlobalConstant.CoordinateSpace.eventDetails)) { rect in
                reactionsRect = rect
            }
        }
        .animation(.none, value: memberInfoOpacity)
        .overlayModal(isPresented: $state.showContext) {
            ReactionContextView(viewModel: viewModel, showStatusContext: $state.showContext, targetRect: $reactionsRect)
        }
        .onChange(of: state.showContext) { showContext in
            if showContext {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    memberInfoOpacity = 0
                }
            } else {
                memberInfoOpacity = 1
            }
        }
    }
}
