//
//  ProfileInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

final class ProfileInteractor {

    private let authorizationService: AuthorizationServiceType?
    
    init(authorizationService: AuthorizationServiceType?) {
        self.authorizationService = authorizationService
    }
}

// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {

    func logout() {
        authorizationService?.logout()
    }
}