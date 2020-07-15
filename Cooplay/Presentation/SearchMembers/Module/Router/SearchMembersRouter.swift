//
//  SearchMembersRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import LightRoute

final class SearchMembersRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - SearchMembersRouterInput

extension SearchMembersRouter: SearchMembersRouterInput {

    func shareInventLink(_ link: URL) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        transitionHandler.present(activityViewController, animated: true, completion: nil)
    }
}
