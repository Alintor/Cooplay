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
import FirebaseFunctions

final class ApplicationFactory {
    
    fileprivate let store: Store
    fileprivate let authorizationService: AuthorizationService
    fileprivate let eventService: EventService
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
        let eventService = EventService(
            firebaseAuth: Auth.auth(),
            firestore: Firestore.firestore(),
            firebaseFunctions: Functions.functions()
        )
        self.authorizationService = authorizationService
        self.eventService = eventService
        self.userService = userService
        self.defaultsStorage = defaultsStorage
        self.store = Store(
            state: GlobalState(isAuthenticated: authorizationService.isLoggedIn),
            effects: [
                authorizationService,
                NotificationBannerService(),
                eventService,
                userService
            ],
            reducers: [
                GlobalState.reducer,
                NotificationBannerState.reducer,
                EventsState.reducer,
                UserState.reducer
            ]
        )
        if authorizationService.isLoggedIn {
            store.send(.successAuthentication)
        }
    }
}

fileprivate let applicationFactory = ApplicationFactory()

enum ScreenViewFactory {
    
    static func home() -> some View {
        HomeView()
            .environmentObject(HomeState(store: applicationFactory.store))
    }
    
    static func profile(_ profile: Profile, isShown: Binding<Bool>? = nil) -> some View {
        ProfileView()
            .environmentObject(ProfileState(profile: profile, store: applicationFactory.store, isShown: isShown))
    }
    
    static func editProfile(
        _ profile: Profile,
        needShowProfileAvatar: Binding<Bool>? = nil,
        successEditHandler: (() -> Void)? = nil
    ) -> some View {
        EditProfileView()
            .environmentObject(EditProfileState(
                store: applicationFactory.store,
                profile: profile,
                userService: applicationFactory.userService,
                needShowProfileAvatar: needShowProfileAvatar,
                successEditHandler: successEditHandler
            ))
    }
    
    static func reactionsSettings() -> some View {
        ReactionsSettingsView(state: ReactionsSettingsState(defaultsStorage: applicationFactory.defaultsStorage))
    }
}
