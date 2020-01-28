//
//  NewEventViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

protocol NewEventViewInput: class {

    // MARK: - View out

    var output: NewEventModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var calendarAction: (() -> Void)? { get set }
    var searchGameAction: (() -> Void)? { get set }
    var searchMembersAction: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func updateDayDate(with model: NewEventDayDateViewModel)
}
