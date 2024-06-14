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
    let coverPath: String?
    let previewImagePath: String?
    
    init(slug: String, name: String, coverPath: String?, previewImagePath: String?) {
        self.slug = slug
        self.name = name
        self.coverPath = coverPath
        self.previewImagePath = previewImagePath
    }
}

extension Game: Equatable {
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.slug == rhs.slug
    }
}

extension Game {
     
    func isEqual(_ game: Game) -> Bool {
        return self.slug == game.slug
        && self.name == game.name
        && self.coverPath == game.coverPath
        && self.previewImagePath == game.previewImagePath
    }
}
