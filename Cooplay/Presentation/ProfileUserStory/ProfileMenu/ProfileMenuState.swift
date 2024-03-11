//
//  ProfileMenuState.swift
//  Cooplay
//
//  Created by Alexandr on 29.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

class ProfileMenuState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    @Published var profile: Profile
    var isShownAvatar: Binding<Bool>
    var isBackButton: Binding<Bool>
    
    // MARK: - Init
    
    init(store: Store, profile: Profile, isShownAvatar: Binding<Bool>, isBackButton: Binding<Bool>) {
        self.store = store
        self.profile = profile
        self.isShownAvatar = isShownAvatar
        self.isBackButton = isBackButton
        store.state
            .map { $0.user.profile }
            .replaceNil(with: profile)
            .removeDuplicates { $0.isEqual($1) }
            .assign(to: &$profile)
    }
    
}
