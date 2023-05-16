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
    private let userService: UserServiceType?
    
    init(eventService: EventServiceType?, userService: UserServiceType?) {
        self.eventService = eventService
        self.userService = userService
    }
}

// MARK: - NewEventInteractorInput

extension NewEventInteractor: NewEventInteractorInput {
    
    func isReady(_ request: NewEventRequest) -> Bool {
        guard
            let date = request.date, !date.isEmpty,
            request.game != nil else { return false }
        return true
    }
    
    func fetchofftenData(
        completion: @escaping (Result<NewEventOfftenDataResponse, NewEventError>) -> Void) {
        userService?.fetchOfftenData { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func createNewEvent(_ request: NewEventRequest) {
        eventService?.createNewEvent(request)
    }
}
