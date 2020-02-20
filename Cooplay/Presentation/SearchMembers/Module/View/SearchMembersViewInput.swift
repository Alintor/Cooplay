//
//  SearchMembersViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import DTModelStorage

protocol SearchMembersViewInput: KeyboardHandler {

    // MARK: - View out

    var output: SearchMembersModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var closeAction: (() -> Void)? { get set }
    var doneAction: (() -> Void)? { get set }
    var inviteAction: (() -> Void)? { get set }
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)? { get set }
    var searchMember: ((_ serchValue: String) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
    func setSelectedMembersDataSource(_ dataSource: UICollectionViewDataSource)
    func showSelectedMembers(_ isShow: Bool, animated: Bool)
    func updateSelectedMembers()
    func setDoneActionEnabled(_ isEnabled: Bool)
}
