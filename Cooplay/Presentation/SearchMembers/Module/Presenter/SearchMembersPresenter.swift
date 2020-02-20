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
                self.selectionHandler?(self.selectedMembersDataSource.items)
                self.router.close(animated: true)
            }
            view.inviteAction = { [weak self] in
                guard let `self` = self else { return }
                // TODO:
                print("Invite by link tapped")
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
    
    private var offtenMembers: [User]!
    private var selectedMembers: [User]!
    private var dataSource: MemoryStorage!
    private var selectionHandler: ((_ members: [User]) -> Void)?
    private var selectedMembersDataSource: SearchMembersDataSource!
    private var searchResults: [User]?
    
    private func setupSelectedMembers() {
        view.showSelectedMembers(!selectedMembers.isEmpty, animated: false)
        view.setDoneActionEnabled(!selectedMembers.isEmpty)
        selectedMembersDataSource = SearchMembersDataSource(with: selectedMembers, selectAction: { [weak self] in
            guard let `self` = self else { return }
            self.updateSelectedMembers()
            self.updateMembersList()
        })
        view.setSelectedMembersDataSource(selectedMembersDataSource)
    }
    
    private func updateSelectedMembers() {
        view.updateSelectedMembers()
        view.showSelectedMembers(!self.selectedMembersDataSource.items.isEmpty, animated: true)
        view.setDoneActionEnabled(!self.selectedMembersDataSource.items.isEmpty)
    }
    
    private func showOfftenMembers() {
        let sectionHeader = offtenMembers.isEmpty ? nil : SearchSectionHeaderViewModel(with: R.string.localizable.searchMembersSectionsOfften())
        dataSource.setSectionHeaderModel(sectionHeader, forSection: 0)
        dataSource.setItems(setupViewModels(offtenMembers), forSection: 0)
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
                    self.showSearchResults(members)
                case .failure(let error):
                    // TODO:
                    break
            }
        }
    }
    
    private func showSearchResults(_ members: [User]) {
        dataSource.setSectionHeaderModel(
            SearchSectionHeaderViewModel(with: R.string.localizable.searchMembersSectionsSearchResults()),
            forSection: 0
        )
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

    func configure(offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?) {
        self.offtenMembers = offtenMembers ?? []
        self.selectedMembers = selectedMembers
        self.selectionHandler = selectionHandler
    }
}
