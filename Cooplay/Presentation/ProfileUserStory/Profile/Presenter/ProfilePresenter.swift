//
//  ProfilePresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

final class ProfilePresenter {

    // MARK: - Properties

    weak var view: ProfileViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
            view.exitAction = { [weak self] in
                self?.interactor.logout()
                self?.router.openIntro()
            }
        }
    }
    var interactor: ProfileInteractorInput!
    var router: ProfileRouterInput!
    
    var state: ProfileState? {
        didSet {
            self.fetchProfile()
        }
    }
    
    private func fetchProfile() {
        interactor.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.state?.update(with: profile)
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {

}

extension ProfilePresenter: ProfileViewOutput {
    
    func itemSelected(_ item: ProfileSettingsItem) {
        print(item.rawValue)
        switch item {
        case .reactions: router.openReactionsSettings()
        case .miniGames: router.openArkanoidGame()
        case .logout:
            router.showLogoutAlert { [ weak self] in
                self?.interactor.logout()
                self?.router.openIntro()
            }
        case .edit:
            guard let profile = state?.profile else { return }
            
            router.openEdit(profile: profile)
        default:
            break
        }
    }
}
