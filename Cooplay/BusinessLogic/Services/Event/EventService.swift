//
//  EventService.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//


import Foundation
import Firebase
import FirebaseFunctions
import SwiftDate

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
    func createNewEvent(_ request: NewEventRequest)
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventServiceError>) -> Void)
    func addEvent(eventId: String, completion: @escaping (Result<Event, EventServiceError>) -> Void)
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventServiceError>) -> Void
    )
    func changeGame(_ game: Game, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
    func changeDate(_ date: String, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
    func removeMember(_ member: User, fromEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
    func addMembers(_ members: [User], toEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
    func takeOwnerRulesToMember(
        _ member: User,
        forEvent event: Event,
        completion: @escaping (Result<Void, EventServiceError>) -> Void
    )
}


final class EventService {
    
    private let storage: HardcodedStorage?
    private let firebaseAuth: Auth
    private let firestore: Firestore
    private let firebaseFunctions: Functions
    
    init(storage: HardcodedStorage?, firebaseAuth: Auth, firestore: Firestore, firebaseFunctions: Functions) {
        self.storage = storage
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
        self.firebaseFunctions = firebaseFunctions
    }
    
}

extension EventService: EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            let response = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: EventFirebaseResponse.self)
            })
            guard let events = response?.map({ $0.getModel(userId: userId )}) else {
                completion(.failure(.unknownError))
                return
            }
            let filteredEvents = events.filter { $0.date >= (Date() - 1.hour)}
            completion(.success(filteredEvents))
            let overdueEvents = events.filter { $0.date < (Date() - 6.months )}
            for overdueEvent in overdueEvents {
                self.deleteEvent(overdueEvent) { (_) in }
            }
        }
        
    }
    
    func createNewEvent(_ request: NewEventRequest) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        func createEvent(user: User) {
            var members = request.members?.map({ user -> User in
                var member = user
                member.status = .unknown
                member.isOwner = false
                return member
            }) ?? []
            members.append(user)
            guard var data = request.dictionary else { return }
            var membersDictionary = [String: Any]()
            for member in members {
                membersDictionary[member.id] = member.dictionary
            }
            data["members"] = membersDictionary
            firestore.collection("Events").document(request.id).setData(data)
            
        }
        firestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let data = snapshot?.data(),
                var user = try? FirestoreDecoder.decode(data, to: User.self) {
                user.status = .accepted
                user.isOwner = true
                createEvent(user: user)
            }
            
        }
    }
    
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Events").document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            if let data = snapshot?.data(),
                let event = try? FirestoreDecoder.decode(data, to: EventFirebaseResponse.self) {
                completion(.success(event.getModel(userId: userId)))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    func addEvent(eventId: String, completion: @escaping (Result<Event, EventServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        func addUserToEvent(user: User) {
            guard let userDictionary = user.dictionary else { return }
            firestore.collection("Events").document(eventId).updateData([
                "members.\(user.id)": userDictionary
            ]) { (error) in
                if let error = error {
                    completion(.failure(.unhandled(error: error)))
                } else {
                    getEvent(id: eventId)
                }
            }
        }
        func getEvent(id: String) {
            firestore.collection("Events").document(id).getDocument { (snapshot, error) in
                if let error = error {
                    completion(.failure(.unhandled(error: error)))
                    return
                }
                if let data = snapshot?.data(),
                    let event = try? FirestoreDecoder.decode(data, to: EventFirebaseResponse.self) {
                    completion(.success(event.getModel(userId: userId)))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
        firestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let data = snapshot?.data(),
                var user = try? FirestoreDecoder.decode(data, to: User.self) {
                user.status = .unknown
                user.isOwner = false
                addUserToEvent(user: user)
            }
            
        }
    }
    
    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var data: [AnyHashable: Any] = [
            "members.\(event.me.id).state": event.me.state?.rawValue as Any
        ]
        data["members.\(event.me.id).lateness"] = event.me.lateness ?? FieldValue.delete()
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
                self?.sendChangeStatusNotification(for: event)
            }
        }
    }
    
    func changeGame(_ game: Game, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var data: [AnyHashable: Any] = [
            "game": game.dictionary as Any
        ]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func changeDate(_ date: String, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var data: [AnyHashable: Any] = ["date": date]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        firestore.collection("Events").document(event.id).delete { [weak self] (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func removeMember(_ member: User, fromEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        firestore.collection("Events").document(event.id).updateData([
            "members.\(member.id)": FieldValue.delete()
        ]) { [weak self] error in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func takeOwnerRulesToMember(_ member: User, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        guard event.me.isOwner == true else {
            // TODO: Send error
            return
        }
        firestore.collection("Event").document(event.id).updateData([
            "members.\(member.id).isOwner": true,
            "members.\(event.me.id).": false
        ]) { [weak self] error in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func membersDataWithResetStatuses(_ members: [User]) -> [AnyHashable: Any] {
        var membersData = [AnyHashable: Any]()
        for member in members {
            membersData["members.\(member.id).lateness"] = FieldValue.delete()
            membersData["members.\(member.id).state"] = User.State.unknown.rawValue
        }
        return membersData
    }
    
    func addMembers(_ members: [User], toEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var membersData = [AnyHashable: Any]()
        for member in members {
            membersData["members.\(member.id)"] = member.dictionary
        }
        firestore.collection("Event").document(event.id).updateData(membersData) { [weak self] error in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Notifications
    private func sendChangeStatusNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendChangeStatusNotification").call(event.dictionary) { (_, _) in }
    }
}
