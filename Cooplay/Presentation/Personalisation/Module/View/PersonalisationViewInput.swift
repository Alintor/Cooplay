//
//  PersonalisationViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

protocol PersonalisationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: PersonalisationModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var confirmAction: (() -> Void)? { get set }
    var changeAvatarAction: (() -> Void)? { get set }
    var nickNameChanged: ((_ nickName: String?) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func updateAvatar(with model: AvatarViewModel)
    func showNickNameErrorMessage(_ message: String)
    func clearNickNameErrorMessage()
    func setConfirmButtonEnabled(_ isEnabled: Bool)
}
