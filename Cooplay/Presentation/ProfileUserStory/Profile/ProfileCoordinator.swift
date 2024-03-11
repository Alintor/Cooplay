//
//  ProfileCoordinator.swift
//  Cooplay
//
//  Created by Alexandr on 29.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

class ProfileCoordinator: ObservableObject {
    
    enum Route: Equatable {
        
        case menu
        case editProfile
        case reactions
        case account
    }
    
    private let store: Store
    @Published var route: Route
    @Published private var profile: Profile
    @Published var isMinigamesShown: Bool = false
    @Published var isLogoutSheetShown: Bool = false
    @Published var isInProgress: Bool = false
    var isShown: Binding<Bool>?
    
    // MARK: - Init
    
    init(profile: Profile, store: Store, isShown: Binding<Bool>?) {
        self.route = .menu
        self.profile = profile
        self.store = store
        self.isShown = isShown
        store.state
            .map { $0.user.profile }
            .replaceNil(with: profile)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$profile)
        store.state
            .map { $0.user.isInProgress }
            .removeDuplicates()
            .assign(to: &$isInProgress)
    }
    
    // MARK: - Methods
    
    var title: String? {
        switch route {
        case .menu: return nil
        case .editProfile: return Localizable.editProfileTitle()
        case .reactions: return Localizable.reactionsSettingsTitle()
        case .account: return Localizable.profileSettingsAccountTitle()
        }
    }
    
    @ViewBuilder func buildView(isShownAvatar: Binding<Bool>, isBackButton: Binding<Bool>) -> some View {
        switch route {
        case .menu:
            ScreenViewFactory.profileMenu(profile: profile, isShownAvatar: isShownAvatar, isBackButton: isBackButton)
                .closable(anchor: .topTrailing, closeHandler: {
                    self.close()
                })
                .zIndex(1)
                .transition(.move(edge: .leading))
        case .editProfile:
            VStack {
                if let title = title {
                    ProfileNavigationView(title: title, isBackButton: isBackButton)
                }
                ScreenViewFactory.editProfile(profile, needShowProfileAvatar: isShownAvatar)
            }
            .closable(anchor: .trailing) {
                self.open(.menu)
            }
            .zIndex(1)
            .transition(.move(edge: .trailing))
        case .reactions:
            VStack {
                if let title = title {
                    ProfileNavigationView(title: title, isBackButton: isBackButton)
                }
                ScreenViewFactory.reactionsSettings()
            }
            .closable(anchor: .trailing) {
                self.open(.menu)
            }
            .zIndex(1)
            .transition(.move(edge: .trailing))
        case .account:
            VStack {
                if let title = title {
                    ProfileNavigationView(title: title, isBackButton: isBackButton)
                }
                ScreenViewFactory.accountSettings()
            }
            .closable(anchor: .trailing) {
                self.open(.menu)
            }
            .zIndex(1)
            .transition(.move(edge: .trailing))
        }
    }
    
    func open(_ nextRoute: Route) {
        route = nextRoute
    }
    
    func showArkanoidGame() {
        isMinigamesShown = true
    }
    
    func showLogoutSheet() {
        isLogoutSheetShown = true
    }
    
    func logout() {
        store.dispatch(.logout)
    }
    
    func close() {
        isShown?.wrappedValue = false
    }
    
}
