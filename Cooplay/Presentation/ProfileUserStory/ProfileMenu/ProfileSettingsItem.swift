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
    delete,
    addPassword,
    linkGoogle = "google.link",
    unlinkGoogle = "google.unlink",
    linkApple = "apple.link",
    unlinkApple = "apple.unlink"
    
    var title: String { NSLocalizedString("profileSettings.\(self.rawValue).title", comment: "") }
    var iconColor: Color {
        switch self {
        case .addPassword:
            Color(.profileSettingsChangePassword)
        case .linkGoogle:
            Color(.textPrimary)
        case .unlinkGoogle:
            Color(.textPrimary)
        case .linkApple:
            Color(.textPrimary)
        case .unlinkApple:
            Color(.textPrimary)
        default:
            Color("profileSettings.\(self.rawValue)")
        }
    }
    var iconImage: Image {
        switch self {
        case .addPassword:
            Image(.profileSettingsChangePassword)
        case .linkGoogle:
            Image(.commonGoogleIcon)
        case .unlinkGoogle:
            Image(.commonGoogleIcon)
        case .linkApple:
            Image(.commonAppleIcon)
        case .unlinkApple:
            Image(.commonAppleIcon)
        default:
            Image("profileSettings.\(self.rawValue)")
        }
    }
    var actionImage: Image? {
        switch self {
        case .logout,
             .miniGames,
             .linkApple,
             .linkGoogle,
             .unlinkApple,
             .unlinkGoogle:
            return Image(R.image.profileSettingsActionTypeSheet.name)
        default:
            return Image(R.image.profileSettingsActionTypeNavigation.name)
        }
    }
    
}
