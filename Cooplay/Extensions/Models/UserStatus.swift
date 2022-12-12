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

extension User.Status {
    
    var color: UIColor {
        switch self {
        case .accepted,
             .ontime:
            return R.color.green()!
        case .maybe,
             .late:
            return R.color.yellow()!
        case .suggestDate:
            return R.color.actionAccent()!
        case .declined:
            return R.color.red()!
        case .unknown:
            return R.color.grey()!
        }
    }
    
    func icon(isSmall: Bool = false) -> UIImage? {
        switch self {
        case .accepted:
            return isSmall ? R.image.statusSmallAccepted() : R.image.statusNormalAccepted()
        case .ontime:
            return isSmall ? R.image.statusSmallOntime() : R.image.statusNormalOntime()
        case .maybe:
            return isSmall ? R.image.statusSmallMaybe() : R.image.statusNormalMaybe()
        case .late:
            return isSmall ? nil : R.image.statusNormalLate()
        case.suggestDate:
            return isSmall ? R.image.statusSmallSuggestDate() : R.image.statusNormalSuggestDate()
        case .declined:
            return isSmall ? R.image.statusSmallDeclined() : R.image.statusNormalDeclined()
        case .unknown:
            return isSmall ? R.image.statusSmallUnknown() : R.image.statusNormalUnknown()
        }
    }
    
    func title(isShort: Bool = false, event: Event) -> String {
        switch self {
        case .accepted:
            return isShort ? R.string.localizable.statusAcceptedShort() : R.string.localizable.statusAcceptedFull()
        case .ontime:
            return isShort ? R.string.localizable.statusOntimeShort() : R.string.localizable.statusOntimeFull()
        case .maybe:
            return isShort ? R.string.localizable.statusMaybeShort() : R.string.localizable.statusMaybeFull()
        case .late(let minutes):
            guard let minutes = minutes else { return R.string.localizable.statusLateShort() }
            return isShort ? R.string.localizable.statusLateShort() : R.string.localizable.statusLateFull(minutes)
        case .suggestDate(let minutes):
            let newDate = event.date + minutes.minutes
            return isShort ? newDate.timeDisplayString : R.string.localizable.statusSuggestDateFull()
        case .declined:
            return isShort ? R.string.localizable.statusDeclinedShort() : R.string.localizable.statusDeclinedFull()
        case .unknown:
            return isShort ? R.string.localizable.statusUnknownShort() : R.string.localizable.statusUnknownFull()
        }
    }
    
    var details: Int? {
        switch self {
        case .late(let minutes):
            return minutes
        default:
            return nil
        }
    }
    
    var detailsString: String? {
        guard let lateTime = details else { return nil }
        return "\(lateTime)"
    }
    
}
