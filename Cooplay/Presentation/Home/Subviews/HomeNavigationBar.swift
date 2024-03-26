//
//  HomeNavigationBar.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeNavigationBar: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: HomeCoordinator
    
    var body: some View {
        ZStack {
            if coordinator.showLoadingIndicator {
                HomeLoadingIndicator()
                    .transition(.opacity)
            }
            HStack {
                eventsIcon
                    .padding()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        coordinator.deselectEvent()
                    }
                if coordinator.isActiveEventPresented {
                    Spacer()
                }
                Image(R.image.commonLogoText.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 16)
                    .clipped()
                    .padding(.leading, coordinator.isActiveEventPresented ? 0 : -16)
                Spacer()
                if let profile = coordinator.profile, !coordinator.hideProfile {
                    AvatarItemView(viewModel: .init(with: profile.user), diameter: 32)
                        .frame(width: 32, height: 32, alignment: .center)
                        .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace.id)
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.show(.profile)
                        }
                }
            }
        }
        .background {
            TransparentBlurView(removeAllFilters: false)
                .blur(radius: 15)
                .padding([.horizontal, .top], -30)
                .frame(width: UIScreen.main.bounds.size.width)
                .opacity(coordinator.isActiveEventPresented ? 0 : 1)
                .ignoresSafeArea()
        }
        .animation(.customTransition, value: coordinator.showLoadingIndicator)
    }
    
    var eventsIcon: some View {
        ZStack {
            if coordinator.invitesCount > 0 && coordinator.isActiveEventPresented {
                InvitesIconView(count: coordinator.invitesCount)
                    .frame(width: 32, height: 32)
                    .zIndex(1)
                    .transition(.scale)
            } else {
                Image(R.image.commonLogoIcon.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(coordinator.isActiveEventPresented ? Color(.textPrimary) : Color(.actionAccent))
                    .frame(width: 32, height: 32)
                    .clipped()
                    .rotationEffect(.degrees(coordinator.isActiveEventPresented ? -180 : 0))
                    .zIndex(1)
                    .transition(.scale)
            }
        }
    }
}
