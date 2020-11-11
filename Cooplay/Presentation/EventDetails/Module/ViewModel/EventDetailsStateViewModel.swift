//
//  EventDetailsStateViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 10/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct EventDetailsStateViewModel {
    
    enum State {
        
        case edit
        case normal
    }
    
    let showEditButton: Bool
    let showDeleteButton: Bool
    let showCancelButton: Bool
    let showEditPanel: Bool
    let hideStatus: Bool
    let title: String?
    
    init(state: State, isOwner: Bool?) {
        switch state {
        case .edit:
            showEditButton = false
            showDeleteButton = true
            showCancelButton = true
            showEditPanel = true
            hideStatus = true
            title = R.string.localizable.eventDetailsEditTitle()
        case .normal:
            showEditButton = isOwner == true
            showDeleteButton = false
            showCancelButton = false
            showEditPanel = false
            hideStatus = false
            title = nil
        }
    }
}
