//
//  ProfileRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

protocol ProfileRouterInput: GuestRoutable {

    func showLogoutAlert(completion: @escaping () -> Void)
    func openReactionsSettings()
    func openArkanoidGame()
}
