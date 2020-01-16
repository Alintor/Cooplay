//
//  EventDetailsViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTModelStorage

protocol EventDetailsViewInput: class {

    // MARK: - View out

    var output: EventDetailsModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)? { get set }
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)? { get set }
    var itemSelected: ((_ item: EventDetailsCellViewModel, _ delegate: StatusContextDelegate?) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func update(with model: EventDetailsViewModel)
}
