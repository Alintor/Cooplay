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
    case fetchEvents
    case fetchActiveEvent
    case changeStatus
    case addReaction
    case deleteEvent
    case changeGame
    case changeDate
    case addMember
    case removeMember
    case takeOwner
    case unhandled(error: Error)
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .fetchEvents: return "Не удалось загрузить события"
        case .fetchActiveEvent: return "Не удалось загрузить событие"
        case .changeStatus: return "Не удалось изменить статус"
        case .addReaction: return "Не удалось добавить реакцию"
        case .deleteEvent: return "Не удалось удалить событие"
        case .changeGame: return "Не удалось изменить игру"
        case .changeDate: return "Не удалось изменить дату события"
        case .addMember: return "Не удалось добавить участников"
        case .removeMember: return "Не удалось исключить участника"
        case .takeOwner: return "Не удалось сделать лидером"
        case .unknownError: return nil // TODO:
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void)
    func createNewEvent(_ request: NewEventRequest)
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventServiceError>) -> Void) -> ListenerRegistration?
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
    func addReaction(_ reaction: Reaction?, to member: User, for event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void)
}


final class EventService {
    
    private let firebaseAuth: Auth
    private let firestore: Firestore
    private let firebaseFunctions: Functions
    private var eventsListener: ListenerRegistration?
    private var activeEventListener: ListenerRegistration?
    private var isFirstFetch = true
    
    init(firebaseAuth: Auth, firestore: Firestore, firebaseFunctions: Functions) {
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
        self.firebaseFunctions = firebaseFunctions
    }
    
}

extension EventService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .logout:
            eventsListener?.remove()
            activeEventListener?.remove()
            eventsListener = nil
            activeEventListener = nil
            
        case .fetchEvents,
             .successAuthentication:
            fetchEvents { [weak self] result in
                switch result {
                case .success(let events):
                    let acceptedEvents = events.filter({ $0.me.state != .unknown && $0.me.state != .declined })
                    if
                        self?.isFirstFetch == true || store.state.value.events.events.isEmpty,
                        acceptedEvents.count == 1,
                        let activeEvent = acceptedEvents.first
                    {
                        store.dispatch(.selectEvent(activeEvent))
                    }
                    store.dispatch(.updateEvents(events.sorted(by: { $0.date < $1.date })))
                    self?.isFirstFetch = false
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .selectEvent(let selectedEvent):
            fetchEvent(id: selectedEvent.id) { result in
                switch result {
                case .success(let event):
                    store.dispatch(.updateActiveEvent(event))
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .deselectEvent:
            activeEventListener?.remove()
            activeEventListener = nil
            
        case .changeStatus(let status, var event):
            guard event.me.status != status else { return }
            
            event.me.status = status
            changeStatus(for: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .addReaction(let reaction, let member, let event):
            addReaction(reaction, to: member, for: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .deleteEvent(let event):
            deleteEvent(event) { result in
                switch result {
                case .success:
                    store.dispatch(.deselectEvent)
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .changeGame(let game, var event):
            event.game = game
            changeGame(game, forEvent: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .changeDate(let date, let event):
            let dateString = date.toString(.custom(GlobalConstant.Format.Date.serverDate.rawValue))
            changeDate(dateString, forEvent: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
        case .addMembers(let members, let event):
            addMembers(members, toEvent: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
        case .removeMember(let member, let event):
            removeMember(member, fromEvent: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
            
        case .makeOwner(let member, let event):
            takeOwnerRulesToMember(member, forEvent: event) { result in
                switch result {
                case .success: break
                case .failure(let error):
                    store.dispatch(.showNetworkError(error))
                }
            }
        default: break
        }
    }
    
}

extension EventService: EventServiceType {
    
    func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void) {
        eventsListener?.remove()
        eventsListener = nil
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        eventsListener = firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            if let _ = error {
                completion(.failure(.fetchEvents))
                return
            }
            let response = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: EventFirebaseResponse.self)
            })
            guard let events = response?.map({ $0.getModel(userId: userId )}) else {
                completion(.failure(.fetchEvents))
                return
            }
            let filteredEvents = events.filter { $0.date >= (Date() - GlobalConstant.eventDurationHours.hours)}
            completion(.success(filteredEvents))
            let overdueEvents = events.filter { $0.date < (Date() - GlobalConstant.eventOverdueMonths.months )}
            for overdueEvent in overdueEvents {
                self.deleteEvent(overdueEvent, sendNotification: false) { (_) in }
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
                member.reactions = nil
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
                let profile = try? FirestoreDecoder.decode(data, to: Profile.self) {
                var user = profile.user
                user.status = .accepted
                user.isOwner = true
                user.reactions = nil
                createEvent(user: user)
            }
            
        }
    }
    
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventServiceError>) -> Void) -> ListenerRegistration? {
        activeEventListener?.remove()
        activeEventListener = nil
        guard let userId = firebaseAuth.currentUser?.uid else { return nil }
        
        activeEventListener = firestore.collection("Events").document(id).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(.fetchActiveEvent))
                return
            }
            if let data = snapshot?.data(),
                let event = try? FirestoreDecoder.decode(data, to: EventFirebaseResponse.self) {
                completion(.success(event.getModel(userId: userId)))
            } else {
                completion(.failure(.fetchActiveEvent))
            }
        }
        return activeEventListener
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
            "members.\(event.me.id).state": event.me.state.rawValue as Any,
            "members.\(event.me.id).reactions": FieldValue.delete()
        ]
        data["members.\(event.me.id).lateness"] = event.me.lateness ?? FieldValue.delete()
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let _ = error {
                completion(.failure(.changeStatus))
            } else {
                self?.sendChangeStatusNotification(for: event)
                completion(.success(()))
            }
        }
    }
    
    func addReaction(_ reaction: Reaction?, to member: User, for event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        let data: [AnyHashable: Any] = [
            "members.\(member.id).reactions.\(event.me.id)": reaction?.dictionary ?? FieldValue.delete()
        ]
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let _ = error {
                completion(.failure(.addReaction))
            } else {
                if let reaction = reaction {
                    self?.sendReactionNotification(reaction, for: member, event: event)
                }
                completion(.success(()))
            }
        }
    }
    
    func changeGame(_ game: Game, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var data: [AnyHashable: Any] = [
            "game": game.dictionary as Any
        ]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let _ = error {
                completion(.failure(.changeGame))
            } else {
                self?.sendChangeEventGameNotification(for: event)
                completion(.success(()))
            }
        }
    }
    
    func changeDate(_ date: String, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        var data: [AnyHashable: Any] = ["date": date]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let _ = error {
                completion(.failure(.changeDate))
            } else {
                self?.sendChangeEventDateNotification(for: event)
                completion(.success(()))
            }
        }
    }
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        deleteEvent(event, sendNotification: true, completion: completion)
    }
    
    private func deleteEvent(_ event: Event, sendNotification: Bool, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        firestore.collection("Events").document(event.id).delete { [weak self] (error) in
            if let _ = error {
                completion(.failure(.deleteEvent))
            } else {
                if sendNotification {
                    self?.sendDeleteEventNotification(for: event)
                }
                completion(.success(()))
            }
        }
    }
    
    func removeMember(_ member: User, fromEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        firestore.collection("Events").document(event.id).updateData([
            "members.\(member.id)": FieldValue.delete()
        ]) { [weak self] error in
            if let _ = error {
                completion(.failure(.removeMember))
            } else {
                self?.sendRemoveMemberFromEventNotification(member: member, event: event)
                completion(.success(()))
            }
        }
    }
    
    func takeOwnerRulesToMember(_ member: User, forEvent event: Event, completion: @escaping (Result<Void, EventServiceError>) -> Void) {
        guard event.me.isOwner == true else {
            completion(.failure(.removeMember))
            return
        }
        firestore.collection("Events").document(event.id).updateData([
            "members.\(member.id).isOwner": true,
            "members.\(event.me.id).isOwner": false
        ]) { [weak self] error in
            if let _ = error {
                completion(.failure(.removeMember))
            } else {
                self?.sendTakeEventOwnerRulesNotification(member: member, event: event)
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
        for var member in members {
            member.status = .unknown
            member.isOwner = false
            member.reactions = nil
            membersData["members.\(member.id)"] = member.dictionary
        }
        firestore.collection("Events").document(event.id).updateData(membersData) { [weak self] error in
            if let _ = error {
                completion(.failure(.addMember))
            } else {
                self?.sendAddMembersToEventNotification(members: members, event: event)
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Notifications
    
    private func sendChangeStatusNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendChangeStatusNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func sendChangeEventGameNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendChangeEventGameNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func sendChangeEventDateNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendChangeEventDateNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func sendDeleteEventNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendDeleteEventNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func sendAddMembersToEventNotification(members: [User], event: Event) {
        let data: [String: Any] = [
            "members": members.map({ $0.dictionary }),
            "event": event.dictionary as Any
        ]
        firebaseFunctions.httpsCallable("sendAddMembersToEventNotification").call(data) { (_, _) in }
    }
    
    private func sendRemoveMemberFromEventNotification(member: User, event: Event) {
        let data = [
            "member":member.dictionary,
            "event": event.dictionary
        ]
        firebaseFunctions.httpsCallable("sendRemoveMemberFromEventNotification").call(data) { (_, _) in }
    }
    
    private func sendTakeEventOwnerRulesNotification(member: User, event: Event) {
        let data = [
            "member":member.dictionary,
            "event": event.dictionary
        ]
        firebaseFunctions.httpsCallable("sendTakeEventOwnerRulesNotification").call(data) { (_, _) in }
    }
    
    private func sendReactionNotification(_ reaction: Reaction, for member: User, event: Event) {
        let data = [
            "reaction": reaction.dictionary,
            "member":member.dictionary,
            "event": event.dictionary
        ]
        firebaseFunctions.httpsCallable("sendAddReactionNotification").call(data) { (_, _) in }
    }
}
