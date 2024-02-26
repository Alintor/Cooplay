//
//  HomeNavigationBar.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeNavigationBar: View {
    
    @EnvironmentObject var state: HomeState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        ZStack {
            if state.isEventsFetching {
                HomeLoadingIndicator()
                    .transition(.opacity)
            }
            HStack {
                eventsIcon
                    .padding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        state.deselectEvent()
                    }
                if state.isActiveEventPresented {
                    Spacer()
                }
                Image(R.image.commonLogoText.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 16)
                    .clipped()
                    .padding(.leading, state.isActiveEventPresented ? 0 : -16)
                Spacer()
                if let profile = state.profile, !state.isShownProfile {
                    AvatarItemView(viewModel: .init(with: profile.user), diameter: 32)
                        .frame(width: 32, height: 32, alignment: .center)
                        .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace.id)
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            state.isShownProfile = true
                        }
                }
            }
        }
        .background {
            TransparentBlurView(removeAllFilters: false)
                .blur(radius: 15)
                .padding([.horizontal, .top], -30)
                .frame(width: UIScreen.main.bounds.size.width)
                .opacity(state.isActiveEventPresented ? 0 : 1)
                .ignoresSafeArea()
        }
        .animation(.customTransition, value: state.isEventsFetching)
    }
    
    var eventsIcon: some View {
        ZStack {
            if state.invitesCount > 0 && state.isActiveEventPresented {
                InvitesIconView(count: state.invitesCount)
                    .frame(width: 32, height: 32)
                    .zIndex(1)
                    .transition(.scale)
            } else {
                Image(R.image.commonLogoIcon.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(state.isActiveEventPresented ? Color(.textPrimary) : Color(.actionAccent))
                    .frame(width: 32, height: 32)
                    .clipped()
                    .rotationEffect(.degrees(state.isActiveEventPresented ? -180 : 0))
                    .zIndex(1)
                    .transition(.scale)
            }
        }
    }
}
