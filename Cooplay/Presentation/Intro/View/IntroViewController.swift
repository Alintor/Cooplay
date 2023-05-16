//
//  IntroViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class IntroViewController: UIViewController, IntroViewInput {

    // MARK: - View out

    var output: IntroViewOutput?

    // MARK: - View in

    func setupInitialState() {

    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
        output?.didLoad()
	}
    
    // MARK: - Actions
    
    @IBAction func authButtonTapped() {
        output?.didTapAuth()
    }
    
    @IBAction func registerButtonTapped() {
        output?.didTapRegister()
    }
    
}
