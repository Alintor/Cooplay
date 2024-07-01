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
    case addEvent
    case fetchOftenData
    case createEvent
    case unhandled(error: Error)
}

extension EventServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .fetchEvents: return Localizable.errorsEventsServiceFetchEvents()
        case .fetchActiveEvent: return Localizable.errorsEventsServiceFetchActiveEvent()
        case .changeStatus: return Localizable.errorsEventsServiceChangeStatus()
        case .addReaction: return Localizable.errorsEventsServiceAddReaction()
        case .deleteEvent: return Localizable.errorsEventsServiceDeleteEvent()
        case .changeGame: return Localizable.errorsEventsServiceChangeGame()
        case .changeDate: return Localizable.errorsEventsServiceChangeDate()
        case .addMember: return Localizable.errorsEventsServiceAddMember()
        case .removeMember: return Localizable.errorsEventsServiceRemoveMember()
        case .takeOwner: return Localizable.errorsEventsServiceTakeOwner()
        case .addEvent: return Localizable.errorsEventsServiceAddEvent()
        case .unknownError: return Localizable.errorsUnknown()
        case .fetchOftenData: return nil
        case .createEvent: return nil
        case .unhandled(let error): return error.localizedDescription
        }
    }
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
    
    // MARK: - Private Methods
    
    private func fetchEvents(completion: @escaping (Result<[Event], EventServiceError>) -> Void) {
        eventsListener?.remove()
        eventsListener = nil
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        AnalyticsService.setUserId(userId)
        eventsListener = firestore.collection("Events").whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId).addSnapshotListener { (snapshot, error) in
            if let _ = error {
                completion(.failure(.fetchEvents))
                return
            }
            let response = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: EventFirebaseResponse.self)
            })
            guard let events = response?.compactMap({ $0.getModel(userId: userId )}) else {
                completion(.failure(.fetchEvents))
                return
            }
            let filteredEvents = events.filter { $0.date >= (Date() - GlobalConstant.eventDurationHours.hours)}
            completion(.success(filteredEvents))
            let overdueEvents = events.filter { $0.date < (Date() - GlobalConstant.eventOverdueMonths.months )}
            for overdueEvent in overdueEvents {
                Task {
                    do {
                        try await self.deleteEvent(overdueEvent, sendNotification: false)
                    }
                    catch { }
                }
            }
        }
        
    }
    
    func createNewEvent(_ request: NewEventRequest) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        func createEvent(user: User) {
            var members = request.members?.map({ user -> User in
                var member = user
                member.status = .invited
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
    
    private func fetchEvent(id: String, completion: @escaping (Result<Event, EventServiceError>) -> Void) {
        activeEventListener?.remove()
        activeEventListener = nil
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        
        activeEventListener = firestore.collection("Events").document(id).addSnapshotListener { (snapshot, error) in
            if let _ = error {
                completion(.failure(.fetchActiveEvent))
                return
            }
            if
                let data = snapshot?.data(),
                let eventData = try? FirestoreDecoder.decode(data, to: EventFirebaseResponse.self),
                let event = eventData.getModel(userId: userId)
            {
                completion(.success(event))
            } else {
                completion(.failure(.fetchActiveEvent))
            }
        }
    }
    
    private func addEvent(eventId: String) async throws -> Event {
        guard let userId = firebaseAuth.currentUser?.uid else { throw EventServiceError.addEvent }
        
        let snapshot = try await firestore.collection("Users").document(userId).getDocument()
        guard
            let data = snapshot.data(),
            let profile = try? FirestoreDecoder.decode(data, to: Profile.self)
        else {
            throw EventServiceError.addEvent
        }
        var user = profile.user
        user.status = .invited
        user.isOwner = false
        guard let userDictionary = user.dictionary else { throw EventServiceError.addEvent }
        try await firestore.collection("Events").document(eventId).updateData([
            "members.\(user.id)": userDictionary
        ])
        let eventSnapshot = try await firestore.collection("Events").document(eventId).getDocument()
        if
            let data = eventSnapshot.data(),
            let eventData = try? FirestoreDecoder.decode(data, to: EventFirebaseResponse.self),
            let event = eventData.getModel(userId: userId)
        {
            return event
        } else {
            throw EventServiceError.addEvent
        }
    }
    
    private func changeStatus(for event: Event, needClearAmount: Bool) async throws {
        var data: [AnyHashable: Any] = [
            "members.\(event.me.id).state": event.me.state.rawValue as Any,
            "members.\(event.me.id).reactions": FieldValue.delete()
        ]
        if needClearAmount || event.me.stateAmount != nil {
            data["members.\(event.me.id).stateAmount"] = event.me.stateAmount ?? FieldValue.delete()
        }
        try await firestore.collection("Events").document(event.id).updateData(data)
        firebaseFunctions.httpsCallable("sendChangeStatusNotification").call(event.dictionary) { (_, _) in }
    }
    
    func addReaction(_ reaction: Reaction?, to member: User, for event: Event) async throws {
        let data: [AnyHashable: Any] = [
            "members.\(member.id).reactions.\(event.me.id)": reaction?.dictionary ?? FieldValue.delete()
        ]
        try await firestore.collection("Events").document(event.id).updateData(data)
        if let reaction = reaction {
            let notificationData = [
                "reaction": reaction.dictionary,
                "member":member.dictionary,
                "event": event.dictionary
            ]
            firebaseFunctions.httpsCallable("sendAddReactionNotification").call(notificationData) { (_, _) in }
        }
    }
    
    private func changeGame(_ game: Game, forEvent event: Event) async throws {
        var data: [AnyHashable: Any] = [
            "game": game.dictionary as Any
        ]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        try await firestore.collection("Events").document(event.id).updateData(data)
        firebaseFunctions.httpsCallable("sendChangeEventGameNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func changeDate(_ date: String, forEvent event: Event) async throws {
        var data: [AnyHashable: Any] = ["date": date]
        membersDataWithResetStatuses(event.members).forEach { data[$0] = $1 }
        try await firestore.collection("Events").document(event.id).updateData(data)
        firebaseFunctions.httpsCallable("sendChangeEventDateNotification").call(event.dictionary) { (_, _) in }
    }
    
    private func deleteEvent(_ event: Event) async throws {
        try await deleteEvent(event, sendNotification: true)
    }
    
    private func deleteEvent(_ event: Event, sendNotification: Bool) async throws {
        try await firestore.collection("Events").document(event.id).delete()
        if sendNotification {
            firebaseFunctions.httpsCallable("sendDeleteEventNotification").call(event.dictionary) { (_, _) in }
        }
    }
    
    private func removeMember(_ member: User, fromEvent event: Event) async throws {
        try await firestore.collection("Events").document(event.id).updateData([
            "members.\(member.id)": FieldValue.delete()
        ])
        let data = [
            "member":member.dictionary,
            "event": event.dictionary
        ]
        firebaseFunctions.httpsCallable("sendRemoveMemberFromEventNotification").call(data) { (_, _) in }
    }
    
    private func takeOwnerRulesToMember(_ member: User, forEvent event: Event) async throws {
        guard event.me.isOwner == true else {
            throw EventServiceError.takeOwner
        }
        try await firestore.collection("Events").document(event.id).updateData([
            "members.\(member.id).isOwner": true,
            "members.\(event.me.id).isOwner": false
        ])
        let data = [
            "member":member.dictionary,
            "event": event.dictionary
        ]
        firebaseFunctions.httpsCallable("sendTakeEventOwnerRulesNotification").call(data) { (_, _) in }
    }
    
    private func membersDataWithResetStatuses(_ members: [User]) -> [AnyHashable: Any] {
        var membersData = [AnyHashable: Any]()
        for member in members {
            membersData["members.\(member.id).state"] = User.State.invited.rawValue
            if member.stateAmount != nil {
                membersData["members.\(member.id).stateAmount"] = FieldValue.delete()
            }
            if member.reactions != nil {
                membersData["members.\(member.id).reactions"] = FieldValue.delete()
            }
        }
        return membersData
    }
    
    private func addMembers(_ members: [User], toEvent event: Event) async throws {
        var membersData = [AnyHashable: Any]()
        for var member in members {
            member.status = .invited
            member.isOwner = false
            member.reactions = nil
            membersData["members.\(member.id)"] = member.dictionary
        }
        try await firestore.collection("Events").document(event.id).updateData(membersData)
        let data: [String: Any] = [
            "members": members.map({ $0.dictionary }),
            "event": event.dictionary as Any
        ]
        firebaseFunctions.httpsCallable("sendAddMembersToEventNotification").call(data) { (_, _) in }
    }
    
}

// MARK: - Middleware

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
                    let acceptedEvents = events.filter({ $0.me.state != .invited && $0.me.state != .declined })
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
            
            let needClearAmount = event.me.stateAmount != nil
            event.me.status = status
            let updatedEvent = event
            Task {
                do {
                    try await changeStatus(for: updatedEvent, needClearAmount: needClearAmount)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.changeStatus))
                }
            }
            
        case .addReaction(let reaction, let member, let event):
            Task {
                do {
                    try await addReaction(reaction, to: member, for: event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.addReaction))
                }
            }
            
        case .deleteEvent(let event):
            store.dispatch(.deselectEvent)
            Task {
                do {
                    try await deleteEvent(event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.deleteEvent))
                }
            }
            
        case .changeGame(let game, var event):
            event.game = game
            let updatedEvent = event
            Task {
                do {
                    try await changeGame(game, forEvent: updatedEvent)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.changeGame))
                }
            }
            
        case .changeDate(let date, let event):
            let dateString = date.toString(.custom(GlobalConstant.Format.Date.serverDate.rawValue))
            Task {
                do {
                    try await changeDate(dateString, forEvent: event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.changeDate))
                }
            }
            
        case .addMembers(let members, let event):
            Task {
                do {
                    try await addMembers(members, toEvent: event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.addMember))
                }
            }
            
        case .removeMember(let member, let event):
            Task {
                do {
                    try await removeMember(member, fromEvent: event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.removeMember))
                }
            }
            
        case .makeOwner(let member, let event):
            Task {
                do {
                    try await takeOwnerRulesToMember(member, forEvent: event)
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.takeOwner))
                }
            }
            
        case.addEvent(let eventId):
            Task {
                do {
                    let event = try await addEvent(eventId: eventId)
                    store.dispatch(.selectEvent(event))
                } catch {
                    store.dispatch(.showNetworkError(EventServiceError.addEvent))
                }
            }
            
        default: break
        }
    }
    
}

protocol EventServiceType {
    
    func createNewEvent(_ request: NewEventRequest)
    func fetchOfftenData(completion: @escaping (Result<NewEventOftenDataResponse, UserServiceError>) -> Void)
    func fetchOftenData() async throws -> NewEventOftenDataResponse
    func createNewEvent(_ request: NewEventRequest) async throws
}

extension EventService: EventServiceType {
    
    func fetchOftenData() async throws -> NewEventOftenDataResponse {
        guard let userId = firebaseAuth.currentUser?.uid else { throw EventServiceError.fetchOftenData }
        
        var members = [(user: User, count: Int)]()
        var games =  [Game]()
        var times = [(time: Date, count: Int)]()
        let snapshot = try await firestore
            .collection("Events")
            .whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId)
            .getDocuments()
        let response = snapshot.documents.compactMap({
            return try? FirestoreDecoder.decode($0.data(), to: EventFirebaseResponse.self)
        })
        let events = response.compactMap({ $0.getModel(userId: userId )})
        let currentDate = Date()
        for event in events.sorted(by: { $0.date > $1.date }) {
            var time = event.date
            let components = Calendar.current.dateComponents(in: .current, from: event.date)
            if
                let hour = components.hour,
                let minute = components.minute,
                let newDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) {
                time = newDate
            }
            if !games.contains(event.game) {
                games.append(event.game)
            }
            if let timeIndex = times.firstIndex(where: { $0.time == time }) {
                var count = times[timeIndex].count
                count += 1
                times[timeIndex] = (time, count)
            } else {
                times.append((time, 1))
            }
            for member in event.members {
                if let memberIndex = members.firstIndex(where: { $0.user == member }) {
                    var count = members[memberIndex].count
                    count += 1
                    members[memberIndex] = (member, count)
                } else {
                    members.append((member, 1))
                }
            }
        }
        let membersSlice = members.sorted(by: { $0.count > $1.count }).map { member -> User in
            var user = member.user
            user.reactions = nil
            return user
        }
        let time = times.sorted(by: { $0.count > $1.count }).map { $0.time }.first
        return NewEventOftenDataResponse(members: Array(membersSlice), games: games, time: time)
    }
    
    func createNewEvent(_ request: NewEventRequest) async throws {
        guard let userId = firebaseAuth.currentUser?.uid else { throw EventServiceError.createEvent }
        
        let userSnapshot = try await firestore.collection("Users").document(userId).getDocument()
        guard let data = userSnapshot.data() else { throw EventServiceError.createEvent }
        
        let profile = try FirestoreDecoder.decode(data, to: Profile.self)
        var user = profile.user
        user.status = .accepted
        user.isOwner = true
        user.reactions = nil
        var members = request.members?.map({ user -> User in
            var member = user
            member.status = .invited
            member.isOwner = false
            member.reactions = nil
            return member
        }) ?? []
        members.append(user)
        guard var data = request.dictionary else { throw EventServiceError.createEvent }
        
        var membersDictionary = [String: Any]()
        for member in members {
            membersDictionary[member.id] = member.dictionary
        }
        data["members"] = membersDictionary
        try await firestore.collection("Events").document(request.id).setData(data)
    }
    
    func fetchOfftenData(completion: @escaping (Result<NewEventOftenDataResponse, UserServiceError>) -> Void) {
        // TODO: Remove error
        // TODO:Add limits
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        var members = [(user: User, count: Int)]()
        var games =  [Game]()
        var times = [(time: Date, count: Int)]()
        firestore.collection("Events")
            .whereField(FieldPath(["members", userId, "id"]), isEqualTo: userId)
            .getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            let response = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: EventFirebaseResponse.self)
            })
            guard let events = response?.compactMap({ $0.getModel(userId: userId )}) else {
                completion(.failure(.unknownError))
                return
            }
            let currentDate = Date()
                for event in events.sorted(by: { $0.date > $1.date }) {
                var time = event.date
                let components = Calendar.current.dateComponents(in: .current, from: event.date)
                if
                    let hour = components.hour,
                    let minute = components.minute,
                    let newDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate) {
                    time = newDate
                }
                if !games.contains(event.game) {
                    games.append(event.game)
                }
//                if let gameIndex = games.firstIndex(where: { $0.game == event.game }) {
//                    var count = games[gameIndex].count
//                    count += 1
//                    games[gameIndex] = (event.game, count)
//                } else {
//                    games.append((event.game, 1))
//                }
                if let timeIndex = times.firstIndex(where: { $0.time == time }) {
                    var count = times[timeIndex].count
                    count += 1
                    times[timeIndex] = (time, count)
                } else {
                    times.append((time, 1))
                }
                for member in event.members {
                    if let memberIndex = members.firstIndex(where: { $0.user == member }) {
                        var count = members[memberIndex].count
                        count += 1
                        members[memberIndex] = (member, count)
                    } else {
                        members.append((member, 1))
                    }
                }
            }
            let membersSlice = members.sorted(by: { $0.count > $1.count }).map { member -> User in
                var user = member.user
                user.reactions = nil
                return user
            }
            //let gamesSlice = games.sorted(by: { $0.count > $1.count }).map { $0.game }
            let time = times.sorted(by: { $0.count > $1.count }).map { $0.time }.first
            completion(.success(NewEventOftenDataResponse(
                members: Array(membersSlice),
                games: games,
                time: time
            )))
        }
    }
    
}
