//
//  OwnerReactionContextView.swift
//  Cooplay
//
//  Created by Alexandr on 15.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct OwnerReactionContextView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @State var contextPresented = false
    @Binding var showReactionsContext: Bool
    var reactionViewModel: ReactionViewModel? {
        ReactionViewModel.build(reactions: state.event.me.reactions ?? [:], event: state.event)
            .first(where: { $0.isOwner })
    }
    
    func close() {
        contextPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showReactionsContext = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            Haptic.play(style: .medium)
        }
    }
    
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
                if contextPresented {
                    HStack {
                        Spacer()
                        ReactionSelectionView(reactions: state.myReactions, selectedReaction: reactionViewModel?.value) { reaction in
                            state.addReaction(reaction, to: state.event.me)
                            close()
                        }
                    }
                    .padding(.trailing, -4)
                    .transition(.scale(scale: 0, anchor: .bottomTrailing).combined(with: .opacity))
                }
                HStack {
                    Spacer()
                    if contextPresented {
                        Image(.commonDetails)
                            .foregroundStyle(Color(.textSecondary))
                            .frame(width: 24, height: 24)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color(.block))
                            .clipShape(.rect(cornerRadius: 15, style: .continuous))
                            .padding(.trailing, -4)
                            .transition(.scale.combined(with: .opacity))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("Tap")
                            }
                    }
                    VStack {
                        if let reactionViewModel = reactionViewModel {
                            ReactionView(viewModel: reactionViewModel, member: state.event.me, isOwner: true)
                                .disabled(true)
                                .transition(.scale.combined(with: .opacity))
                        } else {
                            AddReactionView(member: state.event.me, isOwner: true)
                                .disabled(true)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                    .onTapGesture { close() }
                }
                Spacer()
                    .frame(height: 56)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .animation(.fastTransition, value: contextPresented)
        .animation(.fastTransition, value: state.event.me.reactions)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Haptic.play(style: .medium)
            }
        }
    }
    
}
