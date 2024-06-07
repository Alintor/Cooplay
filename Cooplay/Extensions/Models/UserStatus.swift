//
//  UserStatus.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import SwiftUI

extension User.Status {
    
    var color: Color {
        switch self {
        case .accepted, .ontime: return Color(.green)
        case .maybe, .late: return Color(.yellow)
        case .suggestDate: return Color(.actionAccent)
        case .declined: return Color(.red)
        case .unknown, .invited: return Color(.grey)
        }
    }
    
    var icon: Image {
        switch self {
        case .accepted: return Image(.statusNormalAccepted)
        case .ontime: return Image(.statusNormalOntime)
        case .maybe: return Image(.statusNormalMaybe)
        case .late: return Image(.statusNormalLate)
        case.suggestDate: return Image(.statusNormalSuggestDate)
        case .declined: return Image(.statusNormalDeclined)
        case .unknown, .invited: return Image(.statusNormalUnknown)
        }
    }
    
    var title: String {
        switch self {
        case .accepted: return Localizable.statusAccepted()
        case .ontime: return Localizable.statusOntime()
        case .maybe: return Localizable.statusMaybe()
        case .late(let minutes): return Localizable.statusLate(minutes)
        case .suggestDate: return Localizable.statusSuggestDate()
        case .declined: return Localizable.statusDeclined()
        case .invited: return Localizable.statusInvited()
        case .unknown: return Localizable.statusUnknown()
        }
    }
    
    var contextTitle: String {
        switch self {
        case .accepted: return Localizable.statusContextAccepted()
        case .ontime: return Localizable.statusContextOntime()
        case .maybe: return Localizable.statusContextMaybe()
        case .late: return Localizable.statusContextLate()
        case .suggestDate: return Localizable.statusContextSuggestDate()
        case .declined: return Localizable.statusContextDeclined()
        case .invited, .unknown: return ""
        }
    }
    
}
