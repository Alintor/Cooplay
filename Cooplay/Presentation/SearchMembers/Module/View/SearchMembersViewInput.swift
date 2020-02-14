//
//  SearchMembersViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

protocol SearchMembersViewInput: class {

    // MARK: - View out

    var output: SearchMembersModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
