//
//  PersonalisationInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

protocol PersonalisationInteractorInput: class {

    func validateNickName(_ nickname: String) -> PersonalisationError?
    func setNickname(_ nickname: String, completion: @escaping (Result<Void, PersonalisationError>) -> Void)
}
