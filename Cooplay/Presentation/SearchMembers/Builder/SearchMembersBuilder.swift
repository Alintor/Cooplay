//
//  SearchMembersBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class SearchMembersBuilder {
    
    func build(
        eventId: String,
        offtenMembers: [User]?,
        selectedMembers: [User],
        isEditing: Bool,
        selectionHandler: ((_ members: [User]) -> Void)?
    ) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.searchMembers.searchMembersViewController()!
        let interactor = SearchMembersInteractor(userService: r.resolve(UserServiceType.self))
        let router = SearchMembersRouter(rootViewController: viewController)
        let presenter = SearchMembersPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        presenter.configure(
            eventId: eventId,
            offtenMembers: offtenMembers,
            selectedMembers: selectedMembers,
            isEditing: isEditing,
            selectionHandler: selectionHandler
        )
        viewController.output = presenter
        
        return viewController
    }
}
