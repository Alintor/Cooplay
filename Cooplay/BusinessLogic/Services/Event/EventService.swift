//
//  EventService.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//


import Foundation

enum EventServiceError: Error {
    
    case unhandled(error: Error)
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void)
}


final class EventService {
    
    private let storage: HardcodedStorage?
    
    init(storage: HardcodedStorage?) {
        self.storage = storage
    }
    
}

extension EventService: EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void) {
        
        if let events = storage?.fetchEvents() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completion(.success(events))
            }
            
        }
    }
}
