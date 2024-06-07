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
        ontime,
        maybe,
        late,
        suggestDate,
        declined,
        invited,
        unknown
        
        init(from decoder: Decoder) throws {
            self = try State(
                rawValue: decoder.singleValueContainer().decode(String.self)
            ) ?? .unknown
        }
    }
    
    enum Status: Equatable {
        
        case accepted,
        ontime,
        maybe,
        late(minutes: Int?),
        suggestDate(minutes: Int),
        declined,
        invited,
        unknown
        
        static var agreementStatuses: [Status] {
            return [.accepted, .maybe, .suggestDate(minutes: 0), .declined]
        }
        
        static var confirmationStatuses: [Status] {
            return [.ontime, .late(minutes: nil), .declined]
        }
    }
    
    let id: String
    var name: String
    let avatarPath: String?
    var state: State
    var stateAmount: Int?
    var isOwner: Bool?
    var reactions: [String: Reaction]?
    
}

extension User {
    
    var status: Status {
        get {
            switch state {
            case .accepted:
                return .accepted
            case .ontime:
                return .ontime
            case .late:
                if let minutes = stateAmount, minutes != 0 {
                    return .late(minutes: minutes)
                } else {
                    return .maybe
                }
            case .suggestDate:
                if let minutes = stateAmount {
                    return .suggestDate(minutes: minutes)
                } else {
                    return .maybe
                }
            case .maybe: return .maybe
            case .declined: return .declined
            case .invited: return .invited
            case .unknown: return .unknown
            }
        }
        set {
            switch newValue {
            case .accepted:
                state = .accepted
                stateAmount = nil
            case .ontime:
                state = .ontime
                stateAmount = 0
            case .maybe:
                state = .maybe
                stateAmount = nil
            case .late(let minutes):
                state = .late
                stateAmount = minutes
            case .suggestDate(let minutes):
                state = .suggestDate
                stateAmount = minutes
            case .declined:
                state = .declined
                stateAmount = nil
            case .invited:
                state = .invited
                stateAmount = nil
            case .unknown:
                state = .unknown
                stateAmount = nil
            }
        }
    }
    
}

extension User: Equatable {
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

extension User {
     
    func isEqual(_ user: User) -> Bool {
        return self.id == user.id
        && self.name == user.name
        && self.avatarPath == user.avatarPath
        && self.state == user.state
        && self.stateAmount == user.stateAmount
        && self.isOwner == user.isOwner
        && self.reactions == user.reactions
    }
}

private func ==(lhs: [String: Reaction], rhs: [String: Reaction] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
