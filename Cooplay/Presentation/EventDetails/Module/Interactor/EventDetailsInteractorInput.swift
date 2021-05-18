//
//  EventDetailsInteractorInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation

protocol EventDetailsInteractorInput: class {

    func changeStatus(
        for event: Event,
        completion: @escaping (Result<Void, EventDetailsError>) -> Void
    )
    func changeGame(_ game: Game, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
    func changeDate(_ date: Date, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
    func removeMember(_ member: User, fromEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
    func addMembers(_ members: [User], toEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
    func takeOwnerRulesToMember(_ member: User, forEvent event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
    func fetchEvent(id: String, completion: @escaping (Result<Event, EventDetailsError>) -> Void)
    func deleteEvent(_ event: Event, completion: @escaping (Result<Void, EventDetailsError>) -> Void)
}
