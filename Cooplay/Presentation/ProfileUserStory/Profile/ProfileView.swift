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
    @EnvironmentObject var coordinator: ProfileCoordinator
    @State private var canContinueOffset = true
    @State var isShownAvatar: Bool = true
    @State var isBackButton: Bool = false
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            coordinator.buildView(isShownAvatar: $isShownAvatar, isBackButton: $isBackButton)
            if coordinator.isLogoutSheetShown {
                LogoutSheetView(showAlert: $coordinator.isLogoutSheetShown) {
                    coordinator.logout()
                }
            }
        }
        .animation(.customTransition, value: coordinator.route)
        .activityIndicator(isShown: $coordinator.isInProgress)
        .fullScreenCover(isPresented: $coordinator.isMinigamesShown) {
            ArcanoidView().ignoresSafeArea()
        }
        .onReceive(coordinator.$route) { _ in
            if coordinator.route == .menu {
                isBackButton = false
            } else {
                isBackButton = true
            }
        }
    }
    
}
