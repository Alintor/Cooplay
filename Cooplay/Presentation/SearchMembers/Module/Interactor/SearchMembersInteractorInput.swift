//
//  SearchMembersInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation

protocol SearchMembersInteractorInput: class {

    func searchMember(_ searchValue: String, completion: @escaping (Result<[User], SearchMembersError>) -> Void)
    func fetchOftenMembers(completion: @escaping (Result<[User], SearchMembersError>) -> Void)
    func generateInviteLink(eventId: String, completion: @escaping (_ url: URL) -> Void)
}
