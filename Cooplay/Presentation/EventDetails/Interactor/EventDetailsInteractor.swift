//
//  EventDetailsInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation
import Firebase

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

    private let eventService: EventServiceType
    private var eventListener: ListenerRegistration?
    private let defaultsStorage: DefaultsStorageType
    
    init(eventService: EventServiceType, defaultsStorage: DefaultsStorageType) {
        self.eventService = eventService
        self.defaultsStorage = defaultsStorage
    }
    
    deinit {
        eventListener?.remove()
    }
}

// MARK: - EventDetailsInteractorInput

extension EventDetailsInteractor: EventDetailsInteractorInput {
    
    var mainReaction: Reaction? {
        let defaultsStorages = ApplicationAssembly.assembler.resolver.resolve(DefaultsStorageType.self)
        let reactions = defaultsStorage.get(valueForKey: .reactions) as? [String] ?? GlobalConstant.defaultsReactions
        
        guard let firstReaction = reactions.first else { return nil }
        
        return Reaction(style: .emoji, value: firstReaction)
    }

    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.changeStatus(for: event, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func changeGame(_ game: Game, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.changeGame(game, forEvent: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func changeDate(_ date: Date, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        let dateString = date.string(custom: GlobalConstant.Format.Date.serverDate.rawValue)
        eventService.changeDate(dateString, forEvent: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func removeMember(_ member: User, fromEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.removeMember(member, fromEvent: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func addMembers(_ members: [User], toEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.addMembers(members, toEvent: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func takeOwnerRulesToMember(_ member: User, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.takeOwnerRulesToMember(member, forEvent: event, completion: { (result) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.deleteEvent(event, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventDetailsError>) -> Void) {
        eventListener?.remove()
        eventListener = eventService.fetchEvent(id: id, completion: { result in
            switch result {
            case .success(let event):
                completion(.success(event))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
    
    func addReaction(_ reaction: Reaction?, to member: User, for event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void) {
        eventService.addReaction(reaction, to: member, for: event) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
