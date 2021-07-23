//
//  SearchMembersPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import DTModelStorage

final class SearchMembersPresenter {

    // MARK: - Properties

    weak var view: SearchMembersViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.setupSelectedMembers()
                self?.view.setupInitialState()
            }
            view.closeAction = { [weak self] in
                self?.router.close(animated: true)
            }
            view.doneAction = { [weak self] in
                guard let `self` = self else { return }
                self.selectionHandler?(self.selectedMembersDataSource.selectedItems)
                self.router.close(animated: true)
            }
            view.inviteAction = { [weak self] in
                guard let `self` = self else { return }
                self.interactor.generateInviteLink(eventId: self.eventId) { [weak self] (url) in
                    self?.router.shareInventLink(url)
                }
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                guard let `self` = self else { return }
                self.dataSource = dataSource
                self.showOfftenMembers()
            }
            view.searchMember = { [weak self] searchValue in
                if searchValue.isEmpty {
                    self?.showOfftenMembers()
                    self?.searchResults = nil
                }
                guard searchValue.count > 2 else { return }
                self?.showMember(searchValue)
            }
        }
    }
    var interactor: SearchMembersInteractorInput!
    var router: SearchMembersRouterInput!
    
    // MARK: - Private
    
    private var eventId: String!
    private var isEditing: Bool = false
    private var offtenMembers: [User]!
    private var selectedMembers: [User]!
    private var dataSource: MemoryStorage!
    private var selectionHandler: ((_ members: [User]) -> Void)?
    private var selectedMembersDataSource: SearchMembersDataSource!
    private var searchResults: [User]?
    
    private func setupSelectedMembers() {
        view.showSelectedMembers(!selectedMembers.isEmpty, animated: false)
        view.setDoneActionEnabled(!selectedMembers.isEmpty)
        selectedMembersDataSource = SearchMembersDataSource(with: selectedMembers, isEditing: isEditing, selectAction: { [weak self] in
            guard let `self` = self else { return }
            self.updateSelectedMembers()
            self.updateMembersList()
        })
        view.setSelectedMembersDataSource(selectedMembersDataSource)
    }
    
    private func updateSelectedMembers() {
        view.updateSelectedMembers()
        view.showSelectedMembers(!self.selectedMembersDataSource.items.isEmpty, animated: true)
        view.setDoneActionEnabled(!self.selectedMembersDataSource.selectedItems.isEmpty)
    }
    
    private func showOfftenMembers() {
        guard offtenMembers != nil else {
            fetchOftenMembers()
            return
        }
        let sectionHeader = offtenMembers.isEmpty ? nil : SearchSectionHeaderViewModel(with: R.string.localizable.searchMembersSectionsOfften())
        //dataSource.setSectionHeaderModel(sectionHeader, forSection: 0)
        dataSource.headerModelProvider = { index in
            guard index == 0 else { return nil }
            return sectionHeader
        }
        dataSource.setItems(setupViewModels(offtenMembers), forSection: 0)
    }
    
    private func fetchOftenMembers() {
        view.showProgress(indicatorType: .arrows, fullScreen: false)
        interactor.fetchOftenMembers { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success(let members):
                self.offtenMembers = members
            case .failure(let error):
                self.offtenMembers = []
                // TODO:
            }
            self.showOfftenMembers()
        }
    }
    
    private func updateMembersList() {
        if let members = searchResults {
            showSearchResults(members)
        } else {
            showOfftenMembers()
        }
    }
    
    private func showMember(_ searchValue: String) {
        interactor.searchMember(searchValue) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
                case .success(let members):
                    self.searchResults = members
                    self.showSearchResults(members)
                case .failure(let error):
                    // TODO:
                    break
            }
        }
    }
    
    private func showSearchResults(_ members: [User]) {
//        dataSource.setSectionHeaderModel(
//            SearchSectionHeaderViewModel(with: R.string.localizable.searchMembersSectionsSearchResults()),
//            forSection: 0
//        )
        dataSource.headerModelProvider = { index in
            guard index == 0 else { return nil }
            return SearchSectionHeaderViewModel(with: R.string.localizable.searchMembersSectionsSearchResults())
        }
        if members.isEmpty {
            dataSource.setItems(
                [SearchEmptyResultCellViewModel(with: R.string.localizable.searchMembersEmptyResultsTitle())],
                forSection: 0
            )
        } else {
            dataSource.setItems(setupViewModels(members), forSection: 0)
        }
    }
     
    private func setupViewModels(_ members: [User]) -> [SearchMembersCellViewModel] {
        let viewModels = members.map { [weak self] member -> SearchMembersCellViewModel in
            SearchMembersCellViewModel(
                with: member,
                isSelected: self?.selectedMembersDataSource.items.contains(member) ?? false,
                isBlocked: self?.selectedMembersDataSource.isBlockedItem(member) ?? false,
                selectionHandler: { (isSelected) in
                    if isSelected {
                        self?.selectedMembersDataSource.addItem(member)
                    } else {
                        self?.selectedMembersDataSource.removeItem(member)
                    }
                    self?.updateSelectedMembers()
                }
            )
        }
        return viewModels
    }
}

// MARK: - SearchMembersModuleInput

extension SearchMembersPresenter: SearchMembersModuleInput {

    func configure(eventId: String, offtenMembers: [User]?, selectedMembers: [User], isEditing: Bool, selectionHandler: ((_ members: [User]) -> Void)?) {
        self.eventId = eventId
        self.offtenMembers = offtenMembers
        self.selectedMembers = selectedMembers
        self.isEditing = isEditing
        self.selectionHandler = selectionHandler
    }
}
