//
//  SearchGamePresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import Foundation

final class SearchGamePresenter {

    // MARK: - Properties

    weak var view: SearchGameViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: SearchGameInteractorInput!
    var router: SearchGameRouterInput!
}

// MARK: - SearchGameModuleInput

extension SearchGamePresenter: SearchGameModuleInput {

}
