//
//  SearchGameViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import UIKit

final class SearchGameViewController: UIViewController, SearchGameViewInput {

    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: - View out

    var output: SearchGameModuleInput?
    var viewIsReady: (() -> Void)?

    // MARK: - View in

    func setupInitialState() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = R.color.block()
            appearance.shadowColor = R.color.block()
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
