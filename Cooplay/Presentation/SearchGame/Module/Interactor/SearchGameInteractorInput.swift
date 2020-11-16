//
//  SearchGameInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import Foundation

protocol SearchGameInteractorInput: class {

    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], SearchGameError>) -> Void)
    func fetchOfftenGames(completion: @escaping (Result<[Game], SearchGameError>) -> Void)
}
