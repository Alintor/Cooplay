//
//  SearchMembersPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation

final class SearchMembersPresenter {

    // MARK: - Properties

    weak var view: SearchMembersViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: SearchMembersInteractorInput!
    var router: SearchMembersRouterInput!
}

// MARK: - SearchMembersModuleInput

extension SearchMembersPresenter: SearchMembersModuleInput {

    func configure(offtenMembers: [User]?, selectionHandler: ((_ members: [User]) -> Void)?) {
        
    }
}
