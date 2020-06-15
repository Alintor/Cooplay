//
//  RegistrationViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

protocol RegistrationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: RegistrationModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
