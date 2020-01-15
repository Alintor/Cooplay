//
//  EventDetailsViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

protocol EventDetailsViewInput: class {

    // MARK: - View out

    var output: EventDetailsModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
