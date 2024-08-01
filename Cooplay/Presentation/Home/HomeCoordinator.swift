//
//  HomeCoordinator.swift
//  Cooplay
//
//  Created by Alexandr on 14.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

final class HomeCoordinator: ObservableObject {
    
    enum Route: Equatable {
        
        case editProfile(_ profile: Profile)
        case events(_ route: EventRoute)
        case loading
        case logoSpinner
    }
    
    enum EventRoute: Equatable {
        
        case events(_ state: EventsState)
        case newEvent
    }
    
    enum EventsState: Equatable {
        
        case empty
        case list
        case active(event: Event)
    }
    
    enum FullScreenCover: Equatable {
        
        case profile
        case editStatus(event: Event)
    }
    
    enum SheetModal: Identifiable {
        
        case searchGame(oftenGames: [Game]?, selectedGame: Game?, selectionHandler: ((_ game: Game) -> Void)?)
        case searchMembers(eventId: String,
            oftenMembers: [User]?,
            selectedMembers: [User]?,
            isEditing: Bool,
            selectionHandler: ((_ members: [User]) -> Void)?
        )
        
        var id: Int {
            switch self {
            case .searchGame: return 0
            case .searchMembers: return 1
            }
        }
    }
    
    // MARK: - Properties
    
    private let store: Store
    @Published private var activeEvent: Event?
    @Published var profile: Profile?
    @Published var isNoEvents = false
    @Published var invitesCount: Int = 0
    @Published var showLoadingIndicator: Bool
    @Published var showArkanoid = false
    @Published var showNewEvent: Bool = false {
        didSet {
            if showNewEvent {
                AnalyticsService.sendEvent(.openNewEventScreen)
            }
        }
    }
    @Published var showLogoSpinner: Bool = false {
        didSet {
            if showLogoSpinner {
                AnalyticsService.sendEvent(.openLogoSpinnerScreen)
            } else {
                AnalyticsService.sendEvent(.closeLogoSpinnerScreen)
            }
        }
    }
    @Published var fullScreenCover: FullScreenCover?
    @Published var sheetModal: SheetModal?
    @Published var editStatusEventId: String?
    var isActiveEventPresented: Bool {
        activeEvent != nil
    }
    var hideProfile: Bool {
        fullScreenCover?.isProfile == true
    }
    var route: Route {
        guard let profile else { return .loading }
        guard !profile.name.isEmpty else { return .editProfile(profile) }
        guard !showNewEvent else { return .events(.newEvent) }
        
        if let activeEvent {
            return .events(.events(.active(event: activeEvent)))
        } else if showLogoSpinner {
            return .logoSpinner
        } else {
            return .events(.events(isNoEvents ? .empty : .list))
        }
    }
    
    // MARK: - Init
    
    init(store: Store = ApplicationFactory.getStore()) {
        self.store = store
        self.profile = nil
        self.showLoadingIndicator = store.state.value.events.isFetching
        store.state
            .map { $0.user.profile }
            .removeDuplicates {
                guard let profile1 = $0, let profile2 = $1 else { return false }
                return profile1.isEqual(profile2)
            }
            .assign(to: &$profile)
        store.state
            .map { $0.events.activeEvent }
            .removeDuplicates()
            .assign(to: &$activeEvent)
        store.state
            .map { $0.events.events.isEmpty }
            .removeDuplicates()
            .assign(to: &$isNoEvents)
        store.state
            .map { $0.events.isFetching }
            .removeDuplicates()
            .assign(to: &$showLoadingIndicator)
        store.state
            .map {
                let invitesCount = $0.events.inventedEvents.count
                if $0.events.activeEvent?.isAgreed == false {
                    return invitesCount - 1
                } else {
                    return invitesCount
                }
            }
            .removeDuplicates()
            .assign(to: &$invitesCount)
    }
    
    // MARK: - Methods
    
    func show(_ fullScreenCover: FullScreenCover) {
        if fullScreenCover == .profile {
            AnalyticsService.sendEvent(.openProfileScreen)
        }
        self.fullScreenCover = fullScreenCover
        editStatusEventId = fullScreenCover.editStatusEventId
    }
    
    func hideFullScreenCover() {
        fullScreenCover = nil
        editStatusEventId = nil
    }
    
    func deselectEvent() {
        store.dispatch(.deselectEvent)
    }
    
    func fetchEvents() {
        store.dispatch(.fetchEvents)
    }
    
    func changeStatus(_ status: User.Status, for event: Event) {
        store.dispatch(.changeStatus(status, event: event))
    }
    
    func showSheetModal(_ sheet: SheetModal) {
        sheetModal = sheet
    }
    
    func closeSheet() {
        sheetModal = nil
    }
    
    // MARK: - ViewBuilder
    
    @ViewBuilder func buildView() -> some View {
        switch route {
        case .loading:
            ActivityIndicatorView()
                .zIndex(1)
                .transition(.scale.combined(with: .opacity))
        case .logoSpinner:
            LogoSpinnerView()
                .zIndex(1)
                .transition(.opacity)
        case .editProfile(let profile):
            ScreenViewFactory.editProfile(profile, isPersonalization: true)
                .zIndex(1)
                .transition(.move(edge: .bottom))
        case .events(let eventsRoute):
            ZStack {
                switch eventsRoute {
                case .newEvent:
                    //NewEventProxyView { self.showNewEvent = false }
                    ScreenViewFactory.newEvent()
                        .closable(anchor: .trailing) { self.showNewEvent = false }
                        .zIndex(1)
                        .transition(.move(edge: .trailing))
                case .events(let state):
                    ZStack {
                        switch state {
                        case .empty:
                            EmptyEvents() { self.showNewEvent = true }
                                .zIndex(1)
                                .transition(.scale(scale: 0.5).combined(with: .opacity))
                        case .list:
                            ScreenViewFactory.eventsList() { self.showNewEvent = true }
                            .zIndex(1)
                        case .active(let event):
                            ScreenViewFactory.eventDetails(event)
                                .padding(.top, 72)
                                .transition(.scale(scale: 0.5, anchor: .top).combined(with: .opacity))
                                .closable(showBackground: false) {
                                    AnalyticsService.sendEvent(.closeEventDetailsByEdgeSwipe)
                                    self.store.dispatch(.deselectEvent)
                                }
                                .zIndex(1)
                        }
                        VStack {
                            HomeNavigationBar()
                            Spacer()
                        }
                        .zIndex(2)
                    }
                    .transition(.scale(scale: 0.5, anchor: .leading).combined(with: .opacity))
                }
            }
            .blur(radius: hideProfile ? 80 : 0)
            .zIndex(1)
            .disabled(hideProfile)
            .transition(.scale.combined(with: .opacity))
        }
    }
    
}

extension HomeCoordinator.FullScreenCover {
    
    @ViewBuilder func buildView() -> some View {
        switch self {
        case .profile:
            ScreenViewFactory.profile()
                .zIndex(1)
                .transition(.scale(scale: 0, anchor: .topTrailing).combined(with: .opacity))
        case .editStatus(let event):
            EventsListStatusContextView(event: event)
                .zIndex(1)
        }
    }
    
    var isProfile: Bool {
        switch self {
        case .profile: return true
        case .editStatus: return false
        }
    }
    
    var editStatusEventId: String? {
        switch self {
        case .profile: return nil
        case .editStatus(let event): return event.id
        }
    }
}

extension HomeCoordinator.SheetModal {
    
    @ViewBuilder func buildView() -> some View {
        switch self {
        case .searchGame(let oftenGames, let selectedGame, let selectionHandler):
            ScreenViewFactory.searchGame(oftenGames: oftenGames, selectedGame: selectedGame, selectionHandler: selectionHandler)
        case let .searchMembers(eventId, oftenMembers, selectedMembers, isEditing, selectionHandler):
            ScreenViewFactory.searchMembers(
                eventId: eventId,
                oftenMembers: oftenMembers,
                selectedMembers: selectedMembers,
                isEditing: isEditing,
                selectionHandler: selectionHandler
            )
        }
    }
}
