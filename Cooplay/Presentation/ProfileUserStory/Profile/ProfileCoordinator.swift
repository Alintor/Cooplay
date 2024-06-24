//
//  ProfileCoordinator.swift
//  Cooplay
//
//  Created by Alexandr on 29.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

final class ProfileCoordinator: ObservableObject {
    
    enum Route: Equatable {
        
        case menu
        case editProfile
        case reactions
        case notifications
        case writeToUs
        case account(isBack: Bool)
        case changePassword
        case addPassword
        case deleteAccount
    }
    
    private let store: Store
    @Published var route: Route
    @Published private var profile: Profile
    @Published var isMinigamesShown: Bool = false
    @Published var isLogoutSheetShown: Bool = false
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store = ApplicationFactory.getStore()) {
        self.route = .menu
        self.profile = store.state.value.user.profile!
        self.store = store
        store.state
            .map { $0.user.profile }
            .replaceNil(with: profile)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$profile)
    }
    
    // MARK: - Methods
    
    var title: String? {
        switch route {
        case .menu: return nil
        case .editProfile: return Localizable.editProfileTitle()
        case .reactions: return Localizable.reactionsSettingsTitle()
        case .notifications: return Localizable.notificationsSettingsTitle()
        case .account: return Localizable.profileSettingsAccountTitle()
        case .changePassword: return Localizable.changePasswordTitle()
        case .addPassword: return Localizable.addPasswordTitle()
        case .deleteAccount: return Localizable.deleteAccountTitle()
        case .writeToUs: return Localizable.writeToUsTitle()
        }
    }
    
    @ViewBuilder func buildView(isShownAvatar: Binding<Bool>, isBackButton: Binding<Bool>) -> some View {
        switch route {
        case .menu:
            ScreenViewFactory.profileMenu(profile: profile, isShownAvatar: isShownAvatar, isBackButton: isBackButton)
                .closable(anchor: .topTrailing, closeHandler: {
                    AnalyticsService.sendEvent(.closeProfileByEdgeSwipe)
                    self.close?()
                })
                .zIndex(1)
                .transition(.move(edge: .leading))
        case .editProfile:
            ScreenViewFactory.editProfile(profile, needShowProfileAvatar: isShownAvatar, isBackButton: isBackButton) {
                self.open(.menu)
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
        case.notifications:
            VStack {
                if let title = title {
                    ProfileNavigationView(title: title, isBackButton: isBackButton)
                }
                ScreenViewFactory.notificationsSettings()
            }
            .closable(anchor: .trailing) {
                self.open(.menu)
            }
            .zIndex(1)
            .transition(.move(edge: .trailing))
        case .writeToUs:
            VStack {
                if let title = title {
                    ProfileNavigationView(title: title, isBackButton: isBackButton)
                }
                ScreenViewFactory.writeToUs()
            }
            .closable(anchor: .trailing) {
                self.open(.menu)
            }
            .zIndex(1)
            .transition(.move(edge: .trailing))
        case .account(let isBack):
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
            .transition(.asymmetric(
                insertion: isBack ? .move(edge: .leading) : .move(edge: .trailing),
                removal: .opacity
            ))
        case .changePassword:
            ScreenViewFactory.changePassword()
                .closable(anchor: .trailing) {
                    self.open(.account(isBack: true))
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
        case .addPassword:
            ScreenViewFactory.addPassword()
                .closable(anchor: .trailing) {
                    self.open(.account(isBack: true))
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
        case .deleteAccount:
            ScreenViewFactory.deleteAccount()
                .closable(anchor: .trailing) {
                    self.open(.account(isBack: true))
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
    
    func openRateApp() {
        if let url = URL(string: "https://apps.apple.com/app/id\(GlobalConstant.appleAppId)?action=write-review") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showLogoutSheet() {
        isLogoutSheetShown = true
    }
    
    func logout() {
        AnalyticsService.sendEvent(.submitLogout)
        store.dispatch(.logout)
    }
    
}
