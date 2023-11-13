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
    @State var showNewEvent = false
    
    var body: some View {
        ZStack {
            Color(.background)
                .opacity(state.isActiveEventPresented ? 0 : 1)
                .edgesIgnoringSafeArea(.all)
            if let profile = state.profile {
                if profile.name.isEmpty {
                    ScreenViewFactory.editProfile(profile)
                        .environmentObject(NamespaceWrapper(namespace))
                        .zIndex(1)
                        .transition(.move(edge: .bottom))
                } else {
                    eventsView
                        .blur(radius: state.isShownProfile ? 60 : 0)
                        .zIndex(1)
                        .transition(.scale.combined(with: .opacity))
                        .disabled(state.isShownProfile)
                    if state.isShownProfile {
                        ScreenViewFactory.profile(profile, isShown: $state.isShownProfile)
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
        .coordinateSpace(name: GlobalConstant.CoordinateSpace.profile)
        .animation(.customTransition, value: state.isShownProfile)
        .animation(.customTransition, value: showNewEvent)
        .animation(.customTransition, value: state.isNoEvents)
        .animation(.customTransition, value: state.invitesCount)
        .animation(.customTransition, value: state.isActiveEventPresented)
        .animation(.easeIn(duration: 0.2), value: state.profile)
    }
    
    // MARK: - Subviews
    
    var eventsView: some View {
        ZStack {
            if showNewEvent {
                newEvent
            } else {
                ZStack {
                    if state.isNoEvents {
                        EmptyEvents() { showNewEvent = true }
                            .environmentObject(NamespaceWrapper(namespace))
                            .zIndex(1)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    } else {
                        ScreenViewFactory.eventsList() { showNewEvent = true }
                            .environmentObject(NamespaceWrapper(namespace))
                            .zIndex(1)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                            .closable(closeHandler: nil)
                    }
                    VStack {
                        HomeNavigationBar()
                            .environmentObject(NamespaceWrapper(namespace))
                        Spacer()
                    }
                    .zIndex(1000)
                }
                .transition(.scale(scale: 0.5, anchor: .leading).combined(with: .opacity))
            }
        }
    }
    
    var newEvent: some View {
        NewEventView { showNewEvent = false }
        .closable { showNewEvent = false }
        .transition(.move(edge: .trailing))
    }
    
}
