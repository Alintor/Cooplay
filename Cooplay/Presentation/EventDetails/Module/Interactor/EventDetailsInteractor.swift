//
//  EventDetailsInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation

enum EventDetailsError: Error {
    
    case unhandled(error: Error)
}

extension EventDetailsError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class EventDetailsInteractor {

    private let eventService: EventServiceType?
    
    init(eventService: EventServiceType?) {
        self.eventService = eventService
    }
}

// MARK: - EventDetailsInteractorInput

extension EventDetailsInteractor: EventDetailsInteractorInput {

    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService?.changeStatus(for: event, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventDetailsError>) -> Void) {
        eventService?.fetchEvent(id: id, completion: { result in
            switch result {
            case .success(let event):
                completion(.success(event))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
}
