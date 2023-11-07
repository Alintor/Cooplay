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
                    ScreenViewFactory.shared.editProfile(profile)
                        .environmentObject(NamespaceWrapper(namespace))
                        .zIndex(1)
                        .transition(.move(edge: .bottom))
                } else {
                    if isShownProfile {
                        ScreenViewFactory.shared.profile(profile, isShown: $isShownProfile)
                            .environmentObject(NamespaceWrapper(namespace))
                            .zIndex(1)
                            //.transition(.scale.combined(with: .opacity))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        eventsView
                            .zIndex(1)
                            .transition(.scale(scale: 0.5, anchor: .top).combined(with: .opacity))
                            //.transition(.scale.combined(with: .opacity))
                    }
                }
            } else {
                ProgressView()
            }
        }
        .animation(.customTransition, value: isShownProfile)
        .animation(.easeIn(duration: 0.2), value: state.profile)
    }

    
    var eventsView: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    Image(R.image.commonLogo.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 32)
                        .clipped()
                        .padding()
                    Spacer()
                }
                HStack {
                    Spacer()
                    if let profile = state.profile {
                        AvatarItemView(viewModel: .init(with: profile.user), diameter: 32)
                            .frame(width: 32, height: 32, alignment: .center)
                            .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace)
                            .padding()
                            .onTapGesture {
                                withAnimation {
                                    isShownProfile = true
                                }
                            }
                    }
                }
            }
            Spacer()
            Image(R.image.eventsListEmptyState.name)
            Spacer()
        }
    }
}
