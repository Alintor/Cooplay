//
//  GamesService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

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
}


final class GamesService {
    
    private let storage: HardcodedStorage?
    
    init(storage: HardcodedStorage?) {
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
}
