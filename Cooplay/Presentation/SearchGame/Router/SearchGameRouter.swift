//
//  SearchGameRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import UIKit

final class SearchGameRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - SearchGameRouterInput

extension SearchGameRouter: SearchGameRouterInput {

}
