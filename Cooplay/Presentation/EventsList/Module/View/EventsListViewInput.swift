//
//  EventsListViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

protocol EventsListViewInput: class {

    // MARK: - View out

    var output: EventsListModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
