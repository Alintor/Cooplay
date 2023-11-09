//
//  UserState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

final class UserState {
    
    var profile: Profile? = nil
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .updateProfile(let profile):
            state.user.profile = profile
            return state
        default:
            return state
        }
    }
}
