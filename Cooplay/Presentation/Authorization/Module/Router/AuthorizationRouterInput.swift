//
//  AuthorizationRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

protocol AuthorizationRouterInput: StartRoutable {

    func openRegistration(with email: String?)
    func clearNavigationStack()
}
