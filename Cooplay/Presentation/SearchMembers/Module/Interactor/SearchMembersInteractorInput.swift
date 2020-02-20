//
//  SearchMembersInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation

protocol SearchMembersInteractorInput: class {

    func searchMember(_ searchValue: String, completion: @escaping (Result<[User], SearchMembersError>) -> Void)
}
