//
//  PersonalisationViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit

final class PersonalisationViewController: UIViewController, PersonalisationViewInput {

    // MARK: - View out

    var output: PersonalisationModuleInput?
    var viewIsReady: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {

    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
}
