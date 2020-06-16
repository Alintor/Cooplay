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
    var fieldValueChanged: ((_ field: RegistrationField) -> Void)? { get set }
    var nextAction: (() -> Void)? { get set }
    var checkEmail: (() -> Void)? { get set }
    var loginAction: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func showErrorMessage(_ message: String, forField field: RegistrationField)
    func cleanErrorMessage(forField field: RegistrationField)
    func cleanErrorMessages()
    func setNextButtonEnabled(_ isEnabled: Bool)
    func showEmailChecking()
    func hideEmailChecking()
    func setSymbolsCountErrorState(_ state: PasswordValidationState)
    func setBigSymbolsErrorState(_ state: PasswordValidationState)
    func setNumericSymbolErrorState(_ state: PasswordValidationState)
    func setState(_ state: PasswordValidationState, forField field: RegistrationField)
}
