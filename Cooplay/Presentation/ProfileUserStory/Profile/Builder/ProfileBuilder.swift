//
//  ProfileAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Swinject
import SwinjectStoryboard
import SwiftUI

final class ProfileBuilder {
    
    func build(with profile: Profile) -> UIViewController {
        let container: Container? = ApplicationAssembly.assembler.resolver as? Container
        let interactor = ProfileInteractor(
            authorizationService: container?.resolve(AuthorizationServiceType.self),
            userService: container?.resolve(UserServiceType.self)
        )
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        presenter.interactor = interactor
        presenter.router = router
        let state = ProfileState(profile: profile)
        presenter.state = state
        let viewController = ProfileViewController(contentView: ProfileView(state: state, output: presenter))
        router.rootViewController = viewController
        
        return viewController
    }
}
