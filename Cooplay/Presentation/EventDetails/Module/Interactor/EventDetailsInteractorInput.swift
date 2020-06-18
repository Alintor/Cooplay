//
//  EventDetailsInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation

protocol EventDetailsInteractorInput: class {

    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventDetailsError>) -> Void
    )
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventDetailsError>) -> Void)
}
