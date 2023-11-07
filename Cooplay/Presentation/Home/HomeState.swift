//
//  HomeState.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine

class HomeState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    @Published var profile: Profile?
    
    // MARK: - Init
    
    init(store: Store) {
        self.store = store
        self.profile = nil
        store.state
            .map { $0.user.profile }
            .removeDuplicates {
                guard let profile1 = $0, let profile2 = $1 else { return false }
                return profile1.isEqual(profile2)
            }
            .assign(to: &$profile)
        
    }
    
}
