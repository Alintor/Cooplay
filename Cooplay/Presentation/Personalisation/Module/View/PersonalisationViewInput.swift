//
//  PersonalisationViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

protocol PersonalisationViewInput: class {

    // MARK: - View out

    var output: PersonalisationModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
