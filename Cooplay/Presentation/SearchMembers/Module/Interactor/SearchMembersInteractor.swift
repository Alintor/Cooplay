//
//  SearchMembersInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation

enum SearchMembersError: Error {
    
    case unhandled(error: Error)
}

extension SearchMembersError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class SearchMembersInteractor {

    private let userService: UserServiceType?
    
    init(userService: UserServiceType?) {
        self.userService = userService
    }
}

// MARK: - SearchMembersInteractorInput

extension SearchMembersInteractor: SearchMembersInteractorInput {

    func searchMember(_ searchValue: String, completion: @escaping (Result<[User], SearchMembersError>) -> Void) {
        userService?.searchUser(searchValue) { result in
            switch result {
            case .success(let members):
                completion(.success(members))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
}
