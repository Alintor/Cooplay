//
//  EventsListInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation

protocol EventsListInteractorInput: class {

    func fetchEvents(completion: @escaping (Result<[Event], EventsListError>) -> Void)
}
