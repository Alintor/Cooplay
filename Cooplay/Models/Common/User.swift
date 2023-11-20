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
    var lateness: Int?
    var isOwner: Bool?
    var reactions: [String: Reaction]?
    
}

extension User {
    
    var status: Status {
        get {
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
            switch newValue {
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

extension User {
     
    func isEqual(_ user: User) -> Bool {
        return self.id == user.id
        && self.name == user.name
        && self.avatarPath == user.avatarPath
        && self.state == user.state
        && self.lateness == user.lateness
        && self.isOwner == user.isOwner
        && self.reactions == user.reactions
    }
}

private func ==(lhs: [String: Reaction], rhs: [String: Reaction] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
