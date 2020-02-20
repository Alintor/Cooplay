//
//  SearchMembersViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import DTTableViewManager
import DTModelStorage

final class SearchMembersViewController: UIViewController, SearchMembersViewInput, DTTableViewManageable {
    
    enum Constant {
        
        enum Empty {
            
            static let title = R.string.localizable.searchMembersEmptySateTitle()
            static let description = R.string.localizable.searchMembersEmptySateDescription()
        }
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedMembersView: UIView!
    @IBOutlet weak var selectedMembersCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    // MARK: - View out

    var output: SearchMembersModuleInput?
    var viewIsReady: (() -> Void)?
    var closeAction: (() -> Void)?
    var doneAction: (() -> Void)?
    var inviteAction: (() -> Void)?
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)?
    var searchMember: ((_ serchValue: String) -> Void)?
    
    var keyboardWillShowObserver: NSObjectProtocol?
    var keyboardWillHideObserver: NSObjectProtocol?
    
    private lazy var emptyState = EmptyStateHandler(
        image: nil,
        title: Constant.Empty.title,
        descriptionText: Constant.Empty.description
    )

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
        selectedMembersCollectionView.register(
            UINib(resource: R.nib.newEventMemberCell),
            forCellWithReuseIdentifier: R.reuseIdentifier.newEventMemberCell.identifier
        )
        manager.startManaging(withDelegate: self)
        manager.configureEvents(for: SearchMembersCell.self) { cellType, _ in
            manager.register(cellType)
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
            dataSourceIsReady?(dataSource)
        }
    }
    
    func setSelectedMembersDataSource(_ dataSource: UICollectionViewDataSource) {
        selectedMembersCollectionView.dataSource = dataSource
        selectedMembersCollectionView.reloadData()
    }
    
    func showSelectedMembers(_ isShow: Bool, animated: Bool) {
        guard animated else {
            self.selectedMembersCollectionView.alpha = isShow ? 1 : 0
            self.selectedMembersView.isHidden = !isShow
            return
        }
        UIView.animate(
            withDuration: isShow ? 0.3 : 0,
            delay: isShow ? 0.2 : 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.selectedMembersCollectionView.alpha = isShow ? 1 : 0
        })
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.selectedMembersView.isHidden = !isShow
                self.stackView.layoutIfNeeded()
            }
        )
        
    }
    
    func updateSelectedMembers() {
        DispatchQueue.main.async { [weak self] in
            self?.selectedMembersCollectionView.reloadData()
        }
    }
    
    func setDoneActionEnabled(_ isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }

	// MARK: - Life cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		viewIsReady?()
	}
    
    deinit {
        unregisterFromKeyboardEvents()
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        closeAction?()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        doneAction?()
    }
    
    @IBAction func inviteByLinkButtonTapped(_ sender: UITapGestureRecognizer) {
        inviteAction?()
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
        hideHeaderView(true)
    }
    
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval) {
        tableView.contentInset = .zero
        hideHeaderView(false)
    }
    
    // MARK: - Private
    
    private func hideHeaderView(_ isHide: Bool) {
        guard let headerView = tableView.tableHeaderView else { return }
        let height: CGFloat = isHide ? 0 : 56
        headerView.frame.size.height = height
        tableView.tableHeaderView = headerView
        tableView.layoutIfNeeded()
    }
    
}

extension SearchMembersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchBarTextDidChange(_:)),
            object: searchText
        )
        perform(
            #selector(searchBarTextDidChange(_:)),
            with: searchText,
            afterDelay: 0.3
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func searchBarTextDidChange(_ searchText: String) {
        searchMember?(searchText)
    }
}
