//
//  AuthorizationViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

protocol AuthorizationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: AuthorizationModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var fieldValueChanged: ((_ field: AuthorizationField) -> Void)? { get set }
    var nextAction: (() -> Void)? { get set }
    var checkEmail: (() -> Void)? { get set }
    var passwordRecoveryAction: (() -> Void)? { get set }
    var registrationAction: (() -> Void)? { get set }
    

    // MARK: - View in

    func setupInitialState()
    func showErrorMessage(_ message: String, forField field: AuthorizationField)
    func cleanErrorMessage(forField field: AuthorizationField)
    func cleanErrorMessages()
    func setNextButtonEnabled(_ isEnabled: Bool)
    func showEmailChecking()
    func hideEmailChecking()
    func setEmail(_ text: String)
}
