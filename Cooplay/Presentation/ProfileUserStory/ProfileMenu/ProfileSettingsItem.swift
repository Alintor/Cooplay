//
//  ProfileSettingsItem.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

enum ProfileSettingsItem: String, CaseIterable, Hashable {

    case edit,
    miniGames,
    notifications,
    reactions,
    changePassword,
    account,
    logout,
    delete
    
    var title: String { NSLocalizedString("profileSettings.\(self.rawValue).title", comment: "") }
    var iconColor: Color {
        Color("profileSettings.\(self.rawValue)")
    }
    var iconImage: Image {
        Image("profileSettings.\(self.rawValue)")
    }
    var actionImage: Image? {
        switch self {
        case .logout,
             .miniGames:
            return Image(.profileSettingsActionTypeSheet)
        default:
            return Image(.profileSettingsActionTypeNavigation)
        }
    }
    
}
