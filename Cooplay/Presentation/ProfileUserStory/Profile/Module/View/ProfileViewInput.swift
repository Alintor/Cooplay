//
//  ProfileViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

protocol ProfileViewInput: class {

    // MARK: - View out

    var output: ProfileModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var exitAction: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
