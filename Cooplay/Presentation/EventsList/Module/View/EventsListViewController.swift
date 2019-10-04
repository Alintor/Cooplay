//
//  EventsListViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import UIKit

final class EventsListViewController: UIViewController, EventsListViewInput {

    // MARK: - View out

    var output: EventsListModuleInput?
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
