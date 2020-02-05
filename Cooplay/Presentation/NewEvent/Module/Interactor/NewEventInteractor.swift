//
//  NewEventInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

enum NewEventError: Error {
    
    case unhandled(error: Error)
}

extension NewEventError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class NewEventInteractor {

    private let eventService: EventServiceType?
    private let gamesService: GamesServiceType?
    private let userService: UserServiceType?
    
    init(eventService: EventServiceType?, gamesService: GamesServiceType?, userService: UserServiceType?) {
        self.eventService = eventService
        self.gamesService = gamesService
        self.userService = userService
    }
}

// MARK: - NewEventInteractorInput

extension NewEventInteractor: NewEventInteractorInput {

    func fetchOfftenGames(completion: @escaping (Result<[Game], NewEventError>) -> Void) {
        gamesService?.fetchOfftenGames { result in
            switch result {
            case .success(let games):
                completion(.success(games))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func fetchOfftenMembers(completion: @escaping (Result<[User], NewEventError>) -> Void) {
        userService?.fetchOfftenMembers { result in
            switch result {
            case .success(let members):
                completion(.success(members))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func fetchOfftenTime(completion: @escaping (Result<Date?, NewEventError>) -> Void) {
        userService?.fetchOfftenTime { result in
            switch result {
            case .success(let time):
                completion(.success(time))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
