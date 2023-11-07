//
//  UserState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

class UserState {
    
    var profile: Profile? = nil
    var isEditInProgress = false
    var isEditing = false
    
    static func reducer(state: GlobalState, action: StateAction) -> GlobalState {
        switch action {
        case .updateProfile(let profile):
            state.user.profile = profile
            return state
        case .startEditProfile:
            state.user.isEditing = true
            return state
        case .stopEditProfile:
            state.user.isEditing = false
            return state
        case .editProfileActions:
            state.user.isEditInProgress = true
            return state
        case .successEditingProfile:
            state.user.isEditInProgress = false
            state.user.isEditing = false
            return state
        case .failureEditingProfile:
            state.user.isEditInProgress = false
            return state
        default:
            return state
        }
    }
}
