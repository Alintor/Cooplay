//
//  User.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftDate

struct User: Codable {
    
    enum State: String, Codable {
        
        case accepted,
        maybe,
        declined,
        unknown
    }
    
    enum Status {
        
        case accepted,
        ontime,
        maybe,
        late(minutes: Int?),
        suggestDate(minutes: Int),
        declined,
        unknown
        
        static var agreementStatuses: [Status] {
            return [.accepted, .maybe, .suggestDate(minutes: 0), .declined]
        }
        
        static var confirmationStatuses: [Status] {
            return [.ontime, .late(minutes: nil), .declined]
        }
        
        var color: UIColor? {
            switch self {
            case .accepted,
                 .ontime:
                return R.color.green()
            case .maybe,
                 .late:
                return R.color.yellow()
            case .suggestDate:
                return R.color.actionAccent()
            case .declined:
                return R.color.red()
            case .unknown:
                return R.color.grey()
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
                return isSmall ? R.image.statusNormalLate() : R.image.statusNormalLate()
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
    
    let id: String
    var name: String!
    let avatarPath: String?
    var state: State?
    var lateness: Int?
    var isOwner: Bool?
    
    var status: Status? {
        get {
            guard let state = state else { return nil }
            switch state {
            case .accepted:
                if let lateness = lateness {
                    if lateness == 0 {
                        return .ontime
                    } else {
                        return .late(minutes: lateness)
                    }
                } else {
                    return .accepted
                }
            case .maybe:
                if let lateness = lateness {
                    if lateness == 0 {
                        return .maybe
                    } else {
                        return .suggestDate(minutes: lateness)
                    }
                } else {
                    return .maybe
                }
            case .declined: return.declined
            case .unknown: return .unknown
            }
        }
        
        set {
            guard let status = newValue else {
                state = nil
                lateness = nil
                return
            }
            switch status {
            case .accepted:
                state = .accepted
                lateness = nil
            case .ontime:
                state = .accepted
                lateness = 0
            case .maybe:
                state = .maybe
                lateness = nil
            case .late(let minutes):
                state = .accepted
                lateness = minutes
            case .suggestDate(let minutes):
                state = .maybe
                lateness = minutes
            case .declined:
                state = .declined
                lateness = nil
            case .unknown:
                state = .unknown
                lateness = nil
            }
        }
    }
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
