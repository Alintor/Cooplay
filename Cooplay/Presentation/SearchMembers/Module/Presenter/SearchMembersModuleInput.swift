//
//  SearchMembersModuleInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

protocol SearchMembersModuleInput: class {

    func configure(offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?)
}
