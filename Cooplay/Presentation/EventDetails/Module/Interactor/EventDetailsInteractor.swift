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

}
