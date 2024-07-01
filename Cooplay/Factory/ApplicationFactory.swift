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
    fileprivate let appleAuthorizationService: AppleAuthorizationService
    fileprivate let eventService: EventService
    fileprivate let userService: UserService
    fileprivate let feedbackService: FeedbackService
    fileprivate let defaultsStorage: DefaultsStorage
    
    static func getStore() -> Store {
        applicationFactory.store
    }
    
    init() {
        FirebaseApp.configure()
        let defaultsStorage = DefaultsStorage(defaults: .standard)
        let authorizationService = AuthorizationService(
            firebaseAuth: Auth.auth(),
            firestore: Firestore.firestore(),
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
        feedbackService = FeedbackService(firebaseAuth: Auth.auth(), firestore: Firestore.firestore())
        appleAuthorizationService = AppleAuthorizationService()
        self.authorizationService = authorizationService
        self.eventService = eventService
        self.userService = userService
        self.defaultsStorage = defaultsStorage
        self.store = Store(
            state: GlobalState(isAuthenticated: authorizationService.isLoggedIn),
            middleware: [
                NotificationBannerService(),
                eventService,
                userService,
                authorizationService,
                NotificationsService(),
                DeepLinkService(defaultsStorage: defaultsStorage)
            ],
            reducers: [
                NotificationBannerState.reducer,
                AuthenticationState.reducer,
                EventsState.reducer,
                UserState.reducer
            ]
        )
        if authorizationService.isLoggedIn {
            store.dispatch(.successAuthentication)
        }
    }
}

fileprivate let applicationFactory = ApplicationFactory()

enum ScreenViewFactory {
    
    static func home() -> some View {
        HomeView()
    }
    
    static func eventsList(newEventAction: (() -> Void)?) -> some View {
        EventsListView()
            .environmentObject(EventsListState(store: applicationFactory.store, newEventAction: newEventAction))
    }
    
    static func eventDetails(_ event: Event) -> some View {
        EventDetailsView(state: EventDetailsState(
            store: applicationFactory.store,
            event: event,
            defaultsStorage: applicationFactory.defaultsStorage
        ))
    }
    
    static func newEvent() -> some View {
        NewEventView(state: NewEventState(
            store: applicationFactory.store,
            eventService: applicationFactory.eventService
        ))
    }
    
    static func profile() -> some View {
        ProfileView()
    }
    
    static func profileMenu(profile: Profile, isShownAvatar: Binding<Bool>, isBackButton: Binding<Bool>)  -> some View {
        ProfileMenuView()
            .environmentObject(ProfileMenuState(
                store: applicationFactory.store, 
                profile: profile,
                isShownAvatar: isShownAvatar,
                isBackButton: isBackButton
            ))
    }
    
    static func editProfile(
        _ profile: Profile,
        needShowProfileAvatar: Binding<Bool>? = nil,
        isBackButton: Binding<Bool> = .constant(true),
        isPersonalization: Bool = false,
        backAction: (() -> Void)? = nil
    ) -> some View {
        EditProfileView(state: EditProfileState(
            store: applicationFactory.store,
            profile: profile, 
            userService: applicationFactory.userService,
            needShowProfileAvatar: needShowProfileAvatar,
            isBackButton: isBackButton,
            isPersonalization: isPersonalization,
            backAction: backAction
        ))
    }
    
    static func reactionsSettings() -> some View {
        ReactionsSettingsView(state: ReactionsSettingsState(defaultsStorage: applicationFactory.defaultsStorage))
    }
    
    static func notificationsSettings() -> some View {
        NotificationsSettingsView(state: NotificationsSettingsState(
            store: applicationFactory.store,
            userService: applicationFactory.userService,
            notificationCenter: UNUserNotificationCenter.current()
        ))
    }
    
    static func writeToUs() -> some View {
        WriteToUsView(state: WriteToUsState(
            store: applicationFactory.store,
            feedbackService: applicationFactory.feedbackService
        ))
    }
    
    static func accountSettings() -> some View {
        AccountSettingsView(state: AccountSettingsState(
            store: applicationFactory.store, 
            authorizationService: applicationFactory.authorizationService,
            appleAuthorizationService: applicationFactory.appleAuthorizationService
        ))
    }
    
    static func changePassword() -> some View {
        ChangePasswordView(state: ChangePasswordState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService
        ))
    }
    
    static func addPassword() -> some View {
        AddPasswordView(state: AddPasswordState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService, 
            appleAuthorizationService: applicationFactory.appleAuthorizationService
        ))
    }
    
    static func deleteAccount() -> some View {
        DeleteAccountView(state: DeleteAccountState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService,
            appleAuthorizationService: applicationFactory.appleAuthorizationService
        ))
    }
    
    static func additionalReactions(selectedReaction: String?, handler: ((Reaction?) -> Void)?) -> some View {
        AdditionalReactionsView(state: .init(
            defaultsStorage: applicationFactory.defaultsStorage,
            selectedReaction: selectedReaction,
            handler: handler
        ))
    }
    
    static func authorization() -> some View {
        AuthorizationView()
    }
    
    static func authorizationMenu() -> some View {
        AuthorizationMenuView(state: AuthorizationMenuState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService, 
            appleAuthorizationService: applicationFactory.appleAuthorizationService
        ))
    }
    
    static func login(email: String = "") -> some View {
        LoginView(state: LoginState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService,
            email: email
        ))
    }
    
    static func register(email: String = "") -> some View {
        RegisterView(state: RegisterState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService,
            email: email
        ))
    }
    
    static func resetPassword(oobCode: String) -> some View {
        ResetPasswordView(state: ResetPasswordState(
            store: applicationFactory.store,
            authorizationService: applicationFactory.authorizationService,
            oobCode: oobCode
        ))
    }
    
}
