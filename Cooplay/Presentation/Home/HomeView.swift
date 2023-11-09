//
//  HomeView.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var state: HomeState
    @Namespace var namespace
    @State var isShownProfile: Bool = false
    
    var body: some View {
        ZStack {
            Color.r.background.color
                .edgesIgnoringSafeArea(.all)
            if let profile = state.profile {
                if profile.name.isEmpty {
                    ScreenViewFactory.editProfile(profile)
                        .environmentObject(NamespaceWrapper(namespace))
                        .zIndex(1)
                        .transition(.move(edge: .bottom))
                } else {
                    eventsView
                        .blur(radius: isShownProfile ? 100 : 0)
                        .zIndex(1)
                        .transition(.scale.combined(with: .opacity))
                    if isShownProfile {
                        ScreenViewFactory.profile(profile, isShown: $isShownProfile)
                            .environmentObject(NamespaceWrapper(namespace))
                            .zIndex(1)
                            .transition(.scale(scale: 0, anchor: .topTrailing).combined(with: .opacity))
                    }
                }
            } else {
                ActivityIndicatorView()
                    .zIndex(1)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .activityIndicator(isShown: $state.isInProgress)
        .animation(.customTransition, value: isShownProfile)
        .animation(.easeIn(duration: 0.2), value: state.profile)
    }
    
    var navigationBar: some View {
        HStack {
            Image(R.image.commonLogoIcon.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.r.actionAccent.color)
                .frame(width: 32, height: 32)
                .clipped()
            //Spacer()
            Image(R.image.commonLogoText.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
                .clipped()
            Spacer()
            if let profile = state.profile, !isShownProfile {
                AvatarItemView(viewModel: .init(with: profile.user), diameter: 32)
                    .frame(width: 32, height: 32, alignment: .center)
                    .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace)
                    .onTapGesture {
                        withAnimation {
                            isShownProfile = true
                        }
                    }
            }
        }
        .padding()
    }

    
    var eventsView: some View {
        VStack {
            navigationBar
            EmptyEvents()
        }
    }
}
