//
//  GamesSpecification.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Moya

enum GamesSpecification {
    
    case search(value: String)
}

extension GamesSpecification: APIRequestSpecification {
    
    var baseURL: URL {
        switch self {
        case .search:
            return URL(string: "https://api-v3.igdb.com")!
        }
        
    }
    
    var path: String {
        switch self {
        case .search:
            return "games"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .search(let value):
            let httpBody = "search \"\(value)\"; fields name, slug, cover.*, screenshots.*;"
            guard let data = httpBody.data(using: .utf8, allowLossyConversion: false) else { return .requestPlain }
            return .requestData(data)
        }
    }
    
    var requiresAuthorization: Bool {
        return false
    }
}
