//
//  ProfileAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Swinject
import SwinjectStoryboard
import SwiftUI

final class ProfileAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(ProfileInteractor.self) { r in
			let interactor = ProfileInteractor(
                authorizationService: r.resolve(AuthorizationServiceType.self)
            )

			return interactor
		}

		container.register(ProfileRouter.self) { (_, viewController: UIViewController) in
			let router = ProfileRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(ProfilePresenter.self) { (r, viewController: UIViewController) in
			let presenter = ProfilePresenter()
			//presenter.view = viewController
			presenter.interactor = r.resolve(ProfileInteractor.self)
			presenter.router = r.resolve(ProfileRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(ProfileViewController.self) { r, viewController in
			viewController.output = r.resolve(ProfilePresenter.self, argument: viewController)
		}
	}
}

enum ProfileViewCOnrtollerBuilder {

    static func build(with user: User) -> UIViewController {
        let container: Container? = ApplicationAssembly.assembler.resolver as? Container
        let interactor = ProfileInteractor(
            authorizationService: container?.resolve(AuthorizationServiceType.self)
        )
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        presenter.interactor = interactor
        presenter.router = router
        let viewController = UIHostingController(rootView: ProfileView(state: ProfileState(user: user), output: presenter))
        router.transitionHandler = viewController
        
        return viewController
    }
}


