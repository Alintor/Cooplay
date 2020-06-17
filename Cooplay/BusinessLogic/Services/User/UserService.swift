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
    
    case unhandled(error: Error)
}

extension UserServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
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
        if let members = storage?.fetchOfftenMembers() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(.success(members.filter({ $0.name.lowercased().contains(searchValue.lowercased()) })))
            }
            
        }
    }
    
    func fetchOfftenData(completion: @escaping (Result<NewEventOfftenDataResponse, UserServiceError>) -> Void) {
        let members = storage?.fetchOfftenMembers() ?? []
        let games = storage?.fetchOfftenGames() ?? []
        let response = NewEventOfftenDataResponse(members: members, games: games, time: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            completion(.success(response))
        }
    }
    
    func checkProfileExistanse(completion: @escaping (Result<Bool, UserServiceError>) -> Void) {
        guard let userId = firebaseAuth.currentUser?.uid else { return }
        firestore.collection("Users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            }
            if let snapshot = snapshot, snapshot.exists {
                print(snapshot.data())
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
        let data = ["id": userId, "name": nickname]
        firestore.collection("Users").document(userId).setData(data) { (error) in
            if let error = error {
                completion(.failure(.unhandled(error: error)))
            } else {
                completion(.success(()))
            }
        }
    }
}
