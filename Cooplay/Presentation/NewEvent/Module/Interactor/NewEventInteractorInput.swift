//
//  NewEventInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventInteractorInput: class {

    func fetchofftenData(completion: @escaping (Result<NewEventOfftenDataResponse, NewEventError>) -> Void)
    func isReady(_ request: NewEventRequest) -> Bool
}
