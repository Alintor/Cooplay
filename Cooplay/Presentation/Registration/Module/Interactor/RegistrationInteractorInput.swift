//
//  RegistrationInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

protocol RegistrationInteractorInput: class {

    func validatePassword(_ password: String) -> RegistrationError?
    func validatePasswordConfirmation(
        password: String?,
        confirmPassword: String?
    ) -> RegistrationError?
    func validateEmail(
        _ email: String,
        completion: @escaping (Result<Void, RegistrationError>) -> Void
    )
    func register(
        email: String?,
        password: String?,
        completion: @escaping (Result<User, RegistrationError>) -> Void
    )
}
