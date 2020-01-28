//
//  SearchGameViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

protocol SearchGameViewInput: class {

    // MARK: - View out

    var output: SearchGameModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
