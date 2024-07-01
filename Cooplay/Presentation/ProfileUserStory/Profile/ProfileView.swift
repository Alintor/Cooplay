//
//  ProfileView.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var homeCoordinator: HomeCoordinator
    @StateObject var coordinator = ProfileCoordinator()
    @State private var canContinueOffset = true
    @State var isShownAvatar: Bool = true
    @State var isBackButton: Bool = false
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            coordinator.buildView(isShownAvatar: $isShownAvatar, isBackButton: $isBackButton)
                .environmentObject(coordinator)
            if coordinator.isLogoutSheetShown {
                LogoutSheetView(showAlert: $coordinator.isLogoutSheetShown) {
                    coordinator.logout()
                }
            }
        }
        .animation(.customTransition, value: coordinator.route)
        .fullScreenCover(isPresented: $coordinator.isMinigamesShown) {
            ArkanoidView().ignoresSafeArea()
        }
        .onChange(of: coordinator.route, perform: { newValue in
            if coordinator.route == .menu {
                isBackButton = false
            } else {
                isBackButton = true
            }
        })
        .onAppear {
            coordinator.close = {
                homeCoordinator.hideFullScreenCover()
            }
        }
    }
    
}
