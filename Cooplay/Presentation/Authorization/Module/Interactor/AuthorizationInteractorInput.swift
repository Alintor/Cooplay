//
//  AuthorizationInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

protocol AuthorizationInteractorInput: class {

    func isReady(email: String?, password: String?) -> Bool
    func tryLogin(
        email: String?,
        password: String?,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void
    )
    func checkEmail(
        _ email: String,
        completion: @escaping (Result<Void, AuthorizationError>) -> Void
    )
}
