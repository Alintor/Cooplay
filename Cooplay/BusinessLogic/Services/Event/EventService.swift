//
//  EventService.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//


import Foundation
import Firebase

enum EventServiceError: Error {
    
    case unknownError
    case unhandled(error: Error)
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return nil // TODO:
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void)
    func createNewEvent(
        _ request: NewEventRequest,
        completion: @escaping (Result<Void, EventServiceError>) -> Void
    )
}


final class EventService {
    
    private let storage: HardcodedStorage?
    private let firebaseAuth: Auth
    private let firestore: Firestore
    
    init(storage: HardcodedStorage?, firebaseAuth: Auth, firestore: Firestore) {
        self.storage = storage
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
    }
    
}

extension EventService: EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void) {
        
        if let events = storage?.fetchEvents() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(events))
            }
            
        }
    }
    
    func createNewEvent(
        _ request: NewEventRequest,
        completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        func createEvent(user: User) {
            var members = request.members?.map({ user -> User in
                var member = user
                member.status = .unknown
                member.isOwner = false
                return member
            }) ?? []
            members.append(user)
            var request = request
            request.members = members
            guard let data = request.dictionary else { return }
            firestore.collection("Events").document(request.id).setData(data) { (error) in
                if let error = error {
                    completion(.failure(.unhandled(error: error)))
                } else {
                    completion(.success(()))
                }
            }
            
        }
        firestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            if let data = snapshot?.data(),
                var user = try? FirestoreDecoder.decode(data, to: User.self) {
                user.status = .accepted
                user.isOwner = true
                createEvent(user: user)
            } else {
                completion(.failure(.unknownError))
            }
            
        }
    }
}
