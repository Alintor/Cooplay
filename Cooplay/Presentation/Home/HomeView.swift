//
//  HomeView.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject var coordinator = HomeCoordinator()
    @Namespace var namespace
    @State var showNewEvent = false
    
    var body: some View {
        ZStack {
            Color(.background)
                .opacity(coordinator.isActiveEventPresented ? 0 : 1)
                .edgesIgnoringSafeArea(.all)
            coordinator.buildView()
                .environmentObject(NamespaceWrapper(namespace))
                .environmentObject(coordinator)
            if let fullScreenCover = coordinator.fullScreenCover {
                fullScreenCover.buildView()
                    .environmentObject(NamespaceWrapper(namespace))
                    .environmentObject(coordinator)
            }
        }
        .coordinateSpace(name: GlobalConstant.CoordinateSpace.home)
        .animation(.customTransition, value: coordinator.isActiveEventPresented)
        .animation(.springTransition, value: coordinator.showNewEvent)
        .animation(.customTransition, value: coordinator.route)
        .animation(.customTransition, value: coordinator.fullScreenCover)
        .overlayModal(isPresented: $coordinator.showArkanoid, content: {
            ArkanoidView().ignoresSafeArea()
        })
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                coordinator.fetchEvents()
            }
        }
    }
    
}
