//
//  UserInfo.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

struct Profile: Codable {
    
    let id: String
    var name: String
    let avatarPath: String?
    var email: String?
    let notificationsInfo: NotificationsInfo?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
        notificationsInfo = try container.decodeIfPresent(NotificationsInfo.self, forKey: .notificationsInfo)
        email = nil
    }
    
    var user: User {
        User(id: id, name: name, avatarPath: avatarPath, state: .unknown, lateness: nil, isOwner: nil)
    }
}

struct NotificationsInfo: Codable, Equatable {
    
    var enableNotifications: Bool
    var needOtherReactions: Bool
    var needReactionsForMe: Bool
    var needStatusChange: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enableNotifications = (try? container.decode(Bool.self, forKey: .enableNotifications)) ?? false
        needOtherReactions = (try? container.decode(Bool.self, forKey: .needOtherReactions)) ?? false
        needReactionsForMe = (try? container.decode(Bool.self, forKey: .needReactionsForMe)) ?? false
        needStatusChange = (try? container.decode(Bool.self, forKey: .needStatusChange)) ?? false
    }
    
    init() {
        enableNotifications = true
        needOtherReactions = true
        needReactionsForMe = true
        needStatusChange = true
    }
    
    func isEqual(_ info: NotificationsInfo) -> Bool {
        return self.enableNotifications == info.enableNotifications
        && self.needOtherReactions == info.needOtherReactions
        && self.needReactionsForMe == info.needReactionsForMe
        && self.needStatusChange == info.needStatusChange
    }
}

extension Profile: Equatable {
    
    func isEqual(_ profile: Profile) -> Bool {
        return self.id == profile.id
        && self.name == profile.name
        && self.avatarPath == profile.avatarPath
        && self.email == profile.email
    }
}
