//
//  NewEventInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventInteractorInput: class {

    func isReady(_ request: NewEventRequest) -> Bool
    func fetchofftenData(
        completion: @escaping (Result<NewEventOfftenDataResponse, NewEventError>) -> Void
    )
    func createNewEvent(_ request: NewEventRequest)
}
