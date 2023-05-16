//
//  SearchMembersRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import UIKit

final class SearchMembersRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - SearchMembersRouterInput

extension SearchMembersRouter: SearchMembersRouterInput {

    func shareInventLink(_ link: URL) {
        let activityViewController = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
