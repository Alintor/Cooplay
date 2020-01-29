//
//  NewEventInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventInteractorInput: class {

    func fetchOfftenGames(completion: @escaping (Result<[Game], NewEventError>) -> Void)
    func fetchOfftenMembers(completion: @escaping (Result<[User], NewEventError>) -> Void)
}
