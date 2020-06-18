//
//  SearchGameViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import DTModelStorage

protocol SearchGameViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: SearchGameModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var closeAction: (() -> Void)? { get set }
    var dataSourceIsReady: ((_ dataSource: MemoryStorage) -> Void)? { get set }
    var itemSelected: ((_ item: SearchGameCellViewModel) -> Void)? { get set }
    var searchGame: ((_ serchValue: String) -> Void)? { get set }

    // MARK: - View in

    func setupInitialState()
}
