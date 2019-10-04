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
    
    init(eventService: EventServiceType?) {
        self.eventService = eventService
    }
}

// MARK: - EventsListInteractorInput

extension EventsListInteractor: EventsListInteractorInput {

    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void) {
        eventService?.fetchEvents { result in
            switch result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
