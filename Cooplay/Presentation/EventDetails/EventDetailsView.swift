//
//  EventDetailsView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

final class ReactionsContextState: ObservableObject {
    
    @Published var showContext = false
}

struct EventDetailsView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @EnvironmentObject var namespace: NamespaceWrapper
    @State private var showStatusContextView = false
    @StateObject private var reactionsContextState = ReactionsContextState()
    @State private var showHeader = false
    @State private var canContinueOffset = true
    @State private var showDeleteAlert = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color(.background)
                .matchedGeometryEffect(id: MatchedAnimations.eventCover(state.event.id).name, in: namespace.id)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    if state.modeState.isEditMode {
                        EventDetailsEditInfoView()
                            .padding(EdgeInsets(top: 64, leading: 16, bottom: 24, trailing: 16))
                            .transition(.scale.combined(with: .opacity))
                        EventDetailsAddMemberView()
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .transition(.scale.combined(with: .opacity))
                            .onTapGesture {
                                state.showAddMembersSheet = true
                            }
                    } else {
                        EventDetailsInfoView()
                            .opacity(showHeader ? 0 : 1)
                            .handleRect(in: .named(GlobalConstant.CoordinateSpace.eventDetails)) { rect in
                                let offset = rect.origin.y - 16
                                if offset >= 100, canContinueOffset {
                                    canContinueOffset = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        Haptic.play(style: .medium)
                                        state.close()
                                    }
                                }
                                showHeader = offset <= -84
                            }
                            .padding(.bottom, 24)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    ForEach(state.members, id:\.name) { item in
                        EventDetailsMemberView(viewModel: .init(with: item, event: state.event))
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .animation(.easeInOut(duration: 0.2))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 104)
            }
            VStack {
                Spacer()
                ownerView
            }
            VStack {
                toolBar
                .padding()
                Spacer()
            }
        }
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .handleRect(in: .global) {
            if state.eventDetailsSize != $0.size {
                state.eventDetailsSize = $0.size
            }
        }
        .overlayModal(isPresented: $showStatusContextView, content: {
            EventDetailsStatusContextView(showStatusContext: $showStatusContextView)
        })
        .overlayModal(isPresented: $reactionsContextState.showContext, content: {
            OwnerReactionContextView(showReactionsContext: $reactionsContextState.showContext)
        })
        .sheet(isPresented: $state.showChangeGameSheet) {
            SearchGameView(selectedGame: state.event.game) { game in
                state.changeGame(game)
                state.changeEditMode()
            }
        }
        .sheet(isPresented: $state.showAddMembersSheet, content: {
            SearchMembersView(eventId: state.event.id, selectedMembers: state.event.members) { members in
                state.addMembers(members)
                state.changeEditMode()
            }
        })
        .alert(Localizable.eventDetailsDeleteAlertTitle(), isPresented: $showDeleteAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.commonDelete(), role: .destructive) {
                state.deleteEvent()
            }
        })
        .coordinateSpace(name: GlobalConstant.CoordinateSpace.eventDetails)
        .animation(.customTransition, value: state.event)
        .animation(.customTransition, value: state.modeState)
        .animation(.customTransition, value: showStatusContextView)
        .animation(.customTransition, value: showHeader)
    }
    
    // MARK: - Subviews
    
    var ownerView: some View {
        VStack(spacing: 0) {
            ReactionsListOwnerView(
                reactions: ReactionViewModel.build(reactions: state.event.me.reactions ?? [:], event: state.event),
                member: state.event.me
            )
            .environmentObject(reactionsContextState)
            .animation(.easeInOut(duration: 0.2))
            EventStatusView(viewModel: .init(with: state.event), isTapped: .constant(false))
                .background(Color(R.color.block.name))
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .matchedGeometryEffect(id: MatchedAnimations.eventStatus(state.event.id).name, in: namespace.id)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                .onTapGesture {
                    showStatusContextView.toggle()
                }
        }
        .background {
            TransparentBlurView(removeAllFilters: false)
                .blur(radius: 15)
                .padding([.horizontal, .bottom], -30)
                .frame(width: UIScreen.main.bounds.size.width)
                .ignoresSafeArea()
        }
    }
    
    var toolBar: some View {
        ZStack {
            if showHeader {
                titleView
            } else if state.modeState.isEditMode {
                TitleView(text: Localizable.eventDetailsEditTitle())
            }
            HStack {
                if state.modeState.isEditMode {
                    Image(.commonClose)
                        .foregroundStyle(Color(.textSecondary))
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.block))
                        .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            state.changeEditMode()
                        }
                }
                Spacer()
                switch state.modeState {
                case .edit:
                    Image(.commonDelete)
                        .foregroundStyle(Color(.red))
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.block))
                        .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            showDeleteAlert = true
                        }
                case .owner:
                    Image(.commonEdit)
                        .foregroundStyle(Color(.textSecondary))
                        .frame(width: 24, height: 24)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.block))
                        .clipShape(.rect(cornerRadius: 24, style: .continuous))
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            state.changeEditMode()
                        }
                case .member: EmptyView()
                }
            }
        }
        .background {
            if showHeader || state.modeState.isEditMode {
                TransparentBlurView(removeAllFilters: false)
                    .blur(radius: 15)
                    .padding([.horizontal, .top], -30)
                    .frame(width: UIScreen.main.bounds.size.width)
                    .ignoresSafeArea()
            }
        }
    }
    
    var titleView: some View {
        VStack(spacing: 2) {
            Text(state.event.game.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(.textPrimary))
                .frame(maxWidth: .infinity, alignment: .center)
                .matchedGeometryEffect(id: MatchedAnimations.gameName(state.event.id).name, in: namespace.id)
            Text(state.event.date.displayString)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(.textSecondary))
                .frame(maxWidth: .infinity, alignment: .center)
                .matchedGeometryEffect(id: MatchedAnimations.eventDate(state.event.id).name, in: namespace.id)
        }
    }
}
