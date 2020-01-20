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
    
    init(eventService: EventServiceType?) {
        self.eventService = eventService
    }
}

// MARK: - NewEventInteractorInput

extension NewEventInteractor: NewEventInteractorInput {

}
