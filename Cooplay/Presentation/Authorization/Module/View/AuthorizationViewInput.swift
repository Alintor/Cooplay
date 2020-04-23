//
//  AuthorizationViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

protocol AuthorizationViewInput: KeyboardHandler {

    // MARK: - View out

    var output: AuthorizationModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
