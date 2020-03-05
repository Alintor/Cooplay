//
//  UserService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

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
}


final class UserService {
    
    private let storage: HardcodedStorage?
    
    init(storage: HardcodedStorage?) {
        self.storage = storage
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
}
