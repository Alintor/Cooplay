//
//  Game.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

struct Game: Codable {
    
    let slug: String
    let name: String
    let coverPath: String
    let previewImagePath: String?
}

extension Game: Equatable {
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.slug == rhs.slug
    }
}
