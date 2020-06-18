//
//  EventsListInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation

enum EventsListError: Error {
    
    case unhandled(error: Error)
}

extension EventsListError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class EventsListInteractor {

    private let eventService: EventServiceType?
    private let userService: UserServiceType?
    
    init(eventService: EventServiceType?, userService: UserServiceType?) {
        self.eventService = eventService
        self.userService = userService
    }
}

// MARK: - EventsListInteractorInput

extension EventsListInteractor: EventsListInteractorInput {

    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void) {
        eventService?.fetchEvents { result in
            switch result {
            case .success(let events):
                completion(.success(events.sorted(by: { $0.date < $1.date })))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<User, EventsListError>) -> Void) {
        userService?.fetchProfile(completion: { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventsListError>) -> Void) {
        eventService?.changeStatus(for: event, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
}
