//
//  EventDetailsViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import UIKit

final class EventDetailsViewController: UIViewController, EventDetailsViewInput {

    // MARK: - View out

    var output: EventDetailsModuleInput?
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
