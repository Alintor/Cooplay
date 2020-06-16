//
//  ProfileViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit

final class ProfileViewController: UIViewController, ProfileViewInput {

    // MARK: - View out

    var output: ProfileModuleInput?
    var viewIsReady: (() -> Void)?
    var exitAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {

    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        exitAction?()
    }
    
}
