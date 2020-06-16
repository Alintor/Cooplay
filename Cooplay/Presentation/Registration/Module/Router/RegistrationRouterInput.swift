//
//  RegistrationRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

protocol RegistrationRouterInput {

    func openAuthorization(with email: String?)
    func clearNavigationStack()
    func openPersonalisation(with user: User)
}
