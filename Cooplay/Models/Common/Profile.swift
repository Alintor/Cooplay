//
//  UserInfo.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

struct Profile: Codable {
    
    let id: String
    var name: String!
    let avatarPath: String?
    var email: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        avatarPath = try container.decodeIfPresent(String.self, forKey: .avatarPath)
        email = nil
    }
    
    var user: User {
        User(id: id, name: name, avatarPath: avatarPath, state: nil, lateness: nil, isOwner: nil)
    }
}
