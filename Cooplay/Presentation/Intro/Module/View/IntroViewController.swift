//
//  IntroViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class IntroViewController: UIViewController, IntroViewInput {

    // MARK: - View out

    var output: IntroModuleInput?
    var viewIsReady: (() -> Void)?
    var authAction: (() -> Void)?
    var registerAction: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {

    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    // MARK: - Actions
    
    @IBAction func authButtonTapped() {
        authAction?()
    }
    
    @IBAction func registerButtonTapped() {
        registerAction?()
    }
    
}
