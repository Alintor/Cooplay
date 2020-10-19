//
//  GamesSpecification.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Moya

enum GamesSpecification {
    
    case search(value: String, accessToken: String)
    case token
}

extension GamesSpecification: APIRequestSpecification {
    
    var baseURL: URL {
        switch self {
        case .search:
            return URL(string: "https://api.igdb.com/v4")!
        case .token:
            return URL(string: "https://id.twitch.tv/oauth2/")!
        }
        
    }
    
    var path: String {
        switch self {
        case .search:
            return "games"
        case .token:
            return "token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .search, .token:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .search(let value, _):
            let httpBody = "search \"\(value)\"; fields name, slug, cover.*, screenshots.*;"
            guard let data = httpBody.data(using: .utf8, allowLossyConversion: false) else { return .requestPlain }
            return .requestData(data)
        case .token:
            return .requestParameters(
                parameters: [
                    "client_id": AppConfiguration.DBClientId,
                    "client_secret": AppConfiguration.DBClientSecret,
                    "grant_type": "client_credentials"
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var requiresAuthorization: Bool {
        return false
    }
    
    var headers: [String : String]? {
        switch self {
        case .search(_, let accessToken):
            return [
                "Client-ID": AppConfiguration.DBClientId,
                "Authorization": accessToken
            ]
        default:
            return nil
        }
    }
}
