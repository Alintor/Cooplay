//
//  SearchMembersModuleInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

protocol SearchMembersModuleInput: class {

    func configure(eventId: String, offtenMembers: [User]?, selectedMembers: [User], isEditing: Bool, selectionHandler: ((_ members: [User]) -> Void)?)
}
