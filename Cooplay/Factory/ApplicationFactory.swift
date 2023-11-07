//
//  ApplicationFactory.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseCore

final class ApplicationFactory {
    
    fileprivate let store: Store
    fileprivate let authorizationService: AuthorizationService
    fileprivate let userService: UserService
    fileprivate let defaultsStorage: DefaultsStorage
    
    init() {
        let defaultsStorage = DefaultsStorage(defaults: .standard)
        let authorizationService = AuthorizationService(
            firebaseAuth: Auth.auth(),
            defaultsStorages: defaultsStorage
        )
        let userService = UserService(
            storage: Storage.storage(),
            firebaseAuth: Auth.auth(),
            firestore: Firestore.firestore()
        )
        self.authorizationService = authorizationService
        self.userService = userService
        self.defaultsStorage = defaultsStorage
        self.store = Store(
            state: GlobalState(isAuthenticated: authorizationService.isLoggedIn),
            effects: [
                authorizationService,
                NotificationBannerService(),
                userService
            ],
            reducers: [
                NotificationBannerState.reducer,
                UserState.reducer
            ]
        )
        if authorizationService.isLoggedIn {
            store.send(.successAuthentication)
        }
    }
}

final class ScreenViewFactory {
    
    fileprivate let applicationFactory = ApplicationFactory()
    fileprivate init(){}
    
    static let shared = ScreenViewFactory()
    
    func home() -> some View {
        HomeView()
            .environmentObject(HomeState(store: applicationFactory.store))
    }
    
    func profile(_ profile: Profile, isShown: Binding<Bool>? = nil) -> some View {
        ProfileView()
            .environmentObject(ProfileState(profile: profile, store: applicationFactory.store, isShown: isShown))
    }
    
    func editProfile(_ profile: Profile, isShown: Binding<Bool>? = nil, needShowProfileAvatar: Binding<Bool>? = nil) -> some View {
        EditProfileView()
            .environmentObject(EditProfileState(
                store: applicationFactory.store,
                profile: profile,
                isShown: isShown,
                needShowProfileAvatar: needShowProfileAvatar
            ))
    }
    
    func reactionsSettings() -> some View {
        ReactionsSettingsView(state: ReactionsSettingsState(defaultsStorage: applicationFactory.defaultsStorage))
    }
}
