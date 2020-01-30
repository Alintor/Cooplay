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
    
    func fetchOfftenMembers(completion: @escaping (Result<[User], UserServiceError>) -> Void)
}


final class UserService {
    
    private let storage: HardcodedStorage?
    
    init(storage: HardcodedStorage?) {
        self.storage = storage
    }
}

extension UserService: UserServiceType {
    
    func fetchOfftenMembers(completion: @escaping (Result<[User], UserServiceError>) -> Void) {
        if let members = storage?.fetchOfftenMembers() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completion(.success(members))
            }
            
        }
    }
}