//
//  SearchGameInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import Foundation

enum SearchGameError: Error {
    
    case unhandled(error: Error)
}

extension SearchGameError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class SearchGameInteractor {
    
    private let gamesService: GamesServiceType?
    private let userService: UserServiceType?
    
    init(gamesService: GamesServiceType?, userService: UserServiceType?) {
        self.gamesService = gamesService
        self.userService = userService
    }

}

// MARK: - SearchGameInteractorInput

extension SearchGameInteractor: SearchGameInteractorInput {
    
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], SearchGameError>) -> Void) {
        gamesService?.searchGame(searchValue) { result in
            switch result {
            case .success(let games):
                completion(.success(games))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func fetchOfftenGames(
        completion: @escaping (Result<[Game], SearchGameError>) -> Void) {
        userService?.fetchOfftenData { result in
            switch result {
            case .success(let response):
                completion(.success(response.games))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }

}
