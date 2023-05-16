//
//  SearchGameViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import DTTableViewManager
import DTModelStorage

final class SearchGameViewController: UIViewController, SearchGameViewInput, DTTableViewManageable {
    
    enum Constant {
        
        enum Empty {
            
            static let title = R.string.localizable.searchGameEmptySateTitle()
            static let description = R.string.localizable.searchGameEmptySateDescription()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View out

    var output: SearchGameViewOutput?
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?
    
    private lazy var emptyState = EmptyStateHandler(
        image: nil,
        title: Constant.Empty.title,
        descriptionText: Constant.Empty.description
    )
    
    var activityIndicatorTargetView: UIView? {
        return tableView
    }

    // MARK: - View in

    func setupInitialState() {
        registerForKeyboardEvents()
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
        
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: SearchGameCell.self) { cellType, _ in
            manager.register(cellType)
            manager.didSelect(cellType) { [weak self] _, model, _ in
                self?.output?.didSelectItem(model)
            }
        }
        manager.configureEvents(for: SearchEmptyResultCell.self) { cellType, _ in
            manager.register(cellType)
        }
        manager.registerNiblessHeader(SearchSectionHeaderView.self)
        manager.heightForHeader(withItem: String.self) { _, _ in
            return UITableView.automaticDimension
        }
        manager.heightForHeader(withItem: SearchSectionHeaderViewModel.self) { _, _ in
            return UITableView.automaticDimension
        }
        manager.estimatedHeightForHeader(withItem: SearchSectionHeaderViewModel.self) { _, _ in
            return 60
        }
        manager.tableViewUpdater?.didUpdateContent = { [weak self] update in
            self?.tableView.isHidden = false
            self?.tableView.reloadEmptyState(self?.emptyState)
        }
        if let dataSource = manager.storage as? MemoryStorage {
            output?.setDataSource(dataSource)
        }
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
        output?.didLoad()
	}
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        output?.didTapClose()
    }
    
    // MARK: - KeyboardHandler
    
    func keyboardWillShow(keyboardHeight: CGFloat, duration: TimeInterval) {
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardHeight,
            right: 0
        )
        tableView.contentInset = contentInset
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        tableView.contentInset = .zero
    }
}

extension SearchGameViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        NSObject.cancelPreviousPerformRequests(
//            withTarget: self,
//            selector: #selector(searchBarTextDidChange(_:)),
//            object: searchText
//        )
//        perform(
//            #selector(searchBarTextDidChange(_:)),
//            with: searchText,
//            afterDelay: 0.3
//        )
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            output?.didSearchGame(searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    @objc func searchBarTextDidChange(_ searchText: String) {
        output?.didSearchGame(searchText)
    }
}

