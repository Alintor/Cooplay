//
//  Game+JSON.swift
//  Cooplay
//
//  Created by Alexandr on 11.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftyJSON

extension Game {
    
    init(with json: JSON ) {
        var coverPath: String? = nil
        if let imagId = json["cover"]["image_id"].string {
            coverPath = "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imagId).jpg"
        }
        var previewImagePath: String? = nil
        if let imagId = json["screenshots"].array?.first?["image_id"].string {
            previewImagePath = "https://images.igdb.com/igdb/image/upload/t_original/\(imagId).jpg"
        }
        slug = json["slug"].stringValue
        name = json["name"].stringValue
        self.coverPath = coverPath
        self.previewImagePath =  previewImagePath
    }
    
}
