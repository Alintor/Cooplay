//
//  ProfileState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

class ProfileState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    @Published var profile: Profile
    @Published var isShownAvatar: Bool
    @Published var isItemNavigated: Bool = false
    @Published var itemNavigation: ProfileSettingsItem.Navigation? = nil
    @Published var isMinigamesShown: Bool = false
    var isShown: Binding<Bool>?
    let settings: [ProfileSettingsItem.Section: [ProfileSettingsItem]] = ProfileSettingsItem.items
    
    // MARK: - Init
    
    init(profile: Profile, store: Store, isShown: Binding<Bool>?) {
        self.store = store
        self.profile = profile
        self.isShownAvatar = true
        self.isShown = isShown
        store.state
            .map { $0.user.profile }
            .replaceNil(with: profile)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$profile)
    }
    
    // MARK: - Methods
    
    func itemSelected(_ item: ProfileSettingsItem) {
        switch item {
        case .edit:
            itemNavigation = item.navigation
        case .reactions:
            itemNavigation = item.navigation
        case .miniGames:
            isMinigamesShown = true
        default: break
        }
    }
    
}
