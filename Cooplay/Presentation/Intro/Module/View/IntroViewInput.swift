//
//  IntroViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

protocol IntroViewInput: class {

    // MARK: - View out

    var output: IntroModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var authAction: (() -> Void)? { get set }
    var registerAction: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
