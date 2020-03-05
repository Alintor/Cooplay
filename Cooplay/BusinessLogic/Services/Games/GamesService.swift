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
    
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void) {
        provider?.sendRequest(requestSpecification: GamesSpecification.search(value: searchValue)
        ) { (result: Result<JSON, MoyaError>) in
            switch result {
            case .success(let response):
                let games = response.array?.map({ Game(with: $0)})
                completion(.success(games ?? []))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
