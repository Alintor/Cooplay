//
//  SearchMembersViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import UIKit

final class SearchMembersViewController: UIViewController, SearchMembersViewInput {
    
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - View out

    var output: SearchMembersModuleInput?
    var viewIsReady: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = R.color.block()
            appearance.shadowColor = R.color.block()
            appearance.titleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            appearance.largeTitleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = R.color.block()
        }
        searchBar.isTranslucent = true // Fix translucent bug
        searchBar.isTranslucent = false
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
}
