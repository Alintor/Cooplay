//
//  UserState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

final class UserState {
    
    var profile: Profile? = nil
    var isInProgress = false
    
    static func reducer(state: GlobalState, action: StoreAction) -> GlobalState {
        switch action {
        case .updateProfile(let profile):
            state.user.profile = profile
            return state
        case .showProfileProgress:
            state.user.isInProgress = true
            return state
        case .hideProfileProgress:
            state.user.isInProgress = false
            return state
        default:
            return state
        }
    }
}
