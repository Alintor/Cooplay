//
//  SearchMembersContract.swift
//  Cooplay
//
//  Created by Alexandr on 15.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import DTModelStorage

// MARK: - View

protocol SearchMembersViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    func setupInitialState()
    func setSelectedMembersDataSource(_ dataSource: UICollectionViewDataSource)
    func showSelectedMembers(_ isShow: Bool, animated: Bool)
    func updateSelectedMembers()
    func setDoneActionEnabled(_ isEnabled: Bool)
}

protocol SearchMembersViewOutput: AnyObject {
    
    func didLoad()
    func didTapClose()
    func didTapDone()
    func didTapInvite()
    func setDataSource(_ dataSource: MemoryStorage)
    func didSearchMember(_ searchValue: String)
}

// MARK: - Interactor

protocol SearchMembersInteractorInput: AnyObject {

    func searchMember(
        _ searchValue: String,
        completion: @escaping (Result<[User], SearchMembersError>) -> Void
    )
    func fetchOftenMembers(completion: @escaping (Result<[User], SearchMembersError>) -> Void)
    func generateInviteLink(eventId: String, completion: @escaping (_ url: URL) -> Void)
}

// MARK: - Router

protocol SearchMembersRouterInput: CloseableRouter {

    func shareInventLink(_ link: URL)
}

// MARK: - Module Input

protocol SearchMembersModuleInput: AnyObject {

    func configure(
        eventId: String,
        offtenMembers: [User]?,
        selectedMembers: [User],
        isEditing: Bool,
        selectionHandler: ((_ members: [User]) -> Void)?
    )
}
