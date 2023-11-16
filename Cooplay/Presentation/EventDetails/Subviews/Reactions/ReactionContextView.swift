//
//  ReactionContextView.swift
//  Cooplay
//
//  Created by Alexandr on 14.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionContextView: View {
    
    @EnvironmentObject var state: EventDetailsState
    let viewModel: EventDetailsMemberViewModel
    @State var contextPresented = false
    @State var showAdditionalReactions = false
    @Binding var showStatusContext: Bool
    @Binding var targetRect: CGRect
    var bottomSpacerHeight: CGFloat {
        state.eventDetailsSize.height - targetRect.origin.y - targetRect.size.height
    }
    var reactionViewModel: ReactionViewModel? {
        viewModel.reactions.first(where: { $0.isOwner })
    }
    
    func close() {
        contextPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showStatusContext = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            Haptic.play(style: .medium)
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
                .onTapGesture {
                    close()
                }
            VStack(spacing: 0) {
                Spacer()
                EventDetailsMemberInfoView(viewModel: viewModel)
                if contextPresented {
                    contextView
                }
                HStack {
                    targetView
                    if contextPresented {
                        additionalReactionsButton
                    }
                    Spacer()
                }
                Spacer()
                    .frame(height: bottomSpacerHeight)
            }
            .padding(.horizontal, 16)
        }
        .animation(.fastTransition, value: contextPresented)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Haptic.play(style: .medium)
            }
        }
        .sheet(isPresented: $showAdditionalReactions) {
            ScreenViewFactory.additionalReactions(selectedReaction: reactionViewModel?.value) { reaction in
                state.addReaction(reaction, to: viewModel.member)
                showAdditionalReactions = false
                close()
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    // MARK: - Subviews
    
    var targetView: some View {
        VStack {
            if let reactionViewModel = reactionViewModel {
                ReactionView(viewModel: reactionViewModel, member: viewModel.member, isOwner: false)
                    .disabled(true)
                    .transition(.scale.combined(with: .opacity))
            } else {
                AddReactionView(member: viewModel.member, isOwner: false)
                    .disabled(true)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 4))
        .onTapGesture { close() }
    }
    
    var contextView: some View {
        HStack {
            ReactionSelectionView(reactions: state.myReactions, selectedReaction: reactionViewModel?.value) { reaction in
                state.addReaction(reaction, to: viewModel.member)
                close()
            }
            Spacer()
        }
        .padding(.top, 4)
        .padding(.leading, -8)
        .transition(.scale(scale: 0, anchor: .bottomLeading).combined(with: .opacity))
    }
    
    var additionalReactionsButton: some View {
        Image(.commonDetails)
            .foregroundStyle(Color(.textSecondary))
            .frame(width: 24, height: 24)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Color(.block))
            .clipShape(.rect(cornerRadius: 15, style: .continuous))
            .padding(.top, 4)
            .padding(.leading, -8)
            .transition(.scale.combined(with: .opacity))
            .contentShape(Rectangle())
            .onTapGesture {
                showAdditionalReactions = true
            }
    }
    
}
