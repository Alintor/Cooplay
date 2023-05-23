//
//  ProfileInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

enum ProfileError: Error {
    
    case unhandled(error: Error)
}

extension ProfileError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class ProfileInteractor {

    private let authorizationService: AuthorizationServiceType?
    private let userService: UserServiceType?
    
    init(authorizationService: AuthorizationServiceType?, userService: UserServiceType?) {
        self.authorizationService = authorizationService
        self.userService = userService
    }
}

// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {

    func logout() {
        userService?.removeNotificationToken()
        authorizationService?.logout()
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, ProfileError>) -> Void) {
        userService?.fetchProfile(completion: { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        })
    }
}
