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
    
    enum Navigation {
        
        case edit
        case reactions
        
        var title: String {
            switch self {
            case .edit: return Localizable.editProfileTitle()
            case .reactions: return Localizable.reactionsSettingsTitle()
            }
        }
    }
    
    enum Section: Int, Hashable, CaseIterable, Identifiable {
        
        case empty = 0,
        settings = 1,
        account = 2
        
        var id: Self { self }
        var title: String {
            switch self {
            case .empty: return ""
            case .settings: return R.string.localizable.profileSettingsSectionSettingsTitle()
            case .account: return R.string.localizable.profileSettingsSectionAccountTitle()
            }
        }
    }

    case edit,
    miniGames,
    notifications,
    reactions,
    changePassword,
    account,
    logout
    
    var title: String { NSLocalizedString("profileSettings.\(self.rawValue).title", comment: "") }
    var iconColor: Color { Color("profileSettings.\(self.rawValue)") }
    var iconImage: Image { Image("profileSettings.\(self.rawValue)") }
    var actionImage: Image? {
        switch self {
        case .logout:
            return Image(R.image.profileSettingsActionTypeSheet.name)
        case .edit,
             .notifications,
             .changePassword,
             .reactions,
             .account:
            return Image(R.image.profileSettingsActionTypeNavigation.name)
        case .miniGames: return nil
        }
    }
    var navigation: Navigation? {
        switch self {
        case .edit: return .edit
        case .reactions: return .reactions
        default: return nil
        }
    }
    
    static var items: [ProfileSettingsItem.Section: [ProfileSettingsItem]] {
        return [
            .empty: [
                edit,
                miniGames
            ],
            .settings: [
                notifications,
                reactions,
                changePassword
            ],
            .account: [
                account,
                logout
            ]
        ]
    }
    
}