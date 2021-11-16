//
//  EventDetailsViewOutput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

protocol EventDetailsViewOutput: AnyObject {
    
    func didLoad()
    func statusAction(with delegate: StatusContextDelegate)
    func itemSelected(_ member: User, delegate: StatusContextDelegate)
    func deleteAction()
    func changeGameAction()
    func changeDateAction(delegate: TimeCarouselContextDelegate)
    func addMemberAction()
}
