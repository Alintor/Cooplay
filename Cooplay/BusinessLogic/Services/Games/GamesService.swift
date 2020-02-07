//
//  GamesService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

enum GamesServiceError: Error {
    
    case unhandled(error: Error)
}

extension GamesServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol GamesServiceType {
    
    func fetchOfftenGames(completion: @escaping (Result<[Game], GamesServiceError>) -> Void)
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void)
}


final class GamesService {
    
    private let provider: APIProviderType?
    private let storage: HardcodedStorage?
    
    init(provider: APIProviderType?, storage: HardcodedStorage?) {
        self.provider = provider
        self.storage = storage
    }
}

extension GamesService: GamesServiceType {
    
    func fetchOfftenGames(completion: @escaping (Result<[Game], GamesServiceError>) -> Void) {
        if let games = storage?.fetchOfftenGames() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(games))
            }
            
        }
    }
    
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void) {
        provider?.sendRequest(requestSpecification: GamesSpecification.search(value: searchValue)
        ) { (result: Result<JSON, MoyaError>) in
            switch result {
            case .success(let response):
                let games = response.array?.map({ json -> Game in
                    var coverPath: String? = nil
                    if let imagId = json["cover"]["image_id"].string {
                        coverPath = "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imagId).jpg"
                    }
                    var previewImagePath: String? = nil
                    if let imagId = json["screenshots"].array?.first?["image_id"].string {
                        previewImagePath = "https://images.igdb.com/igdb/image/upload/t_original/\(imagId).jpg"
                    }
                    return Game(
                        slug: json["slug"].stringValue,
                        name: json["name"].stringValue,
                        coverPath: coverPath,
                        previewImagePath: previewImagePath
                    )
                })
                completion(.success(games ?? []))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
