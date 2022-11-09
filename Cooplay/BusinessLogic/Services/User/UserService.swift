//
//  UserService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase

enum UserServiceError: Error {
    
    case unknownError
    case unhandled(error: Error)
}

extension UserServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return nil // TODO:
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol UserServiceType {
    
    func fetchOfftenData(completion: @escaping (Result<NewEventOfftenDataResponse, UserServiceError>) -> Void)
    func searchUser(_ searchValue: String, completion: @escaping (Result<[User], UserServiceError>) -> Void)
    func checkProfileExistanse(completion: @escaping (Result<Bool, UserServiceError>) -> Void)
    func setNickname(
        _ nickname: String,
        completion: @escaping (Result<Void, UserServiceError>) -> Void
    )
    func fetchProfile(completion: @escaping (Result<Profile, UserServiceError>) -> Void)
    func registerNotificationToken(_ token: String)
}


final class UserService {
    
    private let storage: HardcodedStorage?
    private let firebaseAuth: Auth
    private let firestore: Firestore
    
    init(storage: HardcodedStorage?, firebaseAuth: Auth, firestore: Firestore) {
        self.storage = storage
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
    }
}

extension UserService: UserServiceType {
    
    func searchUser(_ searchValue: String, completion: @escaping (Result<[User], UserServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            let users = snapshot?.documents.compactMap({
                return try? FirestoreDecoder.decode($0.data(), to: Profile.self)
            })
            let filteredUsers = users?.filter({
                $0.name.lowercased().contains(searchValue.lowercased()) && $0.id != userId
            })
            completion(.success(filteredUsers?.map({ $0.user }) ?? []))
        }
        
    }
    
    func fetchOfftenData(completion: @escaping (Result<NewEventOfftenDataResponse, UserServiceError>) -> Void) {
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
            guard let events = response?.map({ $0.getModel(userId: userId )}) else {
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
            completion(.success(NewEventOfftenDataResponse(
                members: Array(membersSlice),
                games: games,
                time: time
            )))
        }
    }
    
    func checkProfileExistanse(completion: @escaping (Result<Bool, UserServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
                return
            }
            if let snapshot = snapshot, snapshot.exists {
                completion(.success(true))
            } else {
                completion(.success(false))
            }
        }
    }
    
    func setNickname(
        _ nickname: String,
        completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        let data = [
            "id": userId,
            "name": nickname,
            "needStatusChangeNotifications": true,
            "needReactionsForMeNotifications": true,
            "needReactionsAllNotifications": true
        ] as [String : Any]
        firestore.collection("Users").document(userId).setData(data) { (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, UserServiceError>) -> Void) {
        guard let currentUser = firebaseAuth.currentUser else { return }
        firestore.collection("Users").document(currentUser.uid).addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            }
            if let data = snapshot?.data(),
                var profile = try? FirestoreDecoder.decode(data, to: Profile.self) {
                profile.email = currentUser.email
                completion(.success(profile))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    func registerNotificationToken(_ token: String) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Users").document(userId).updateData(["notificationToken" : token])
    }
}
