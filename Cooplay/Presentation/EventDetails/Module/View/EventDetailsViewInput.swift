//
//  EventDetailsViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTModelStorage

protocol EventDetailsViewInput: AnyObject {

    var event: Event { get }
    func changeEditMode()
    func update(with event: Event)
    func updateStatus(_ status: User.Status)
    func updateGame(_ game: Game)
    func updateDate(_ date: Date)
    func updateMembers(_ members: [User])
    func takeOwnerRulesToMemberAtIndex(_ index: Int)
}
