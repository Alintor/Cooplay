//
//  NewEventDataSource.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

protocol ConfigurableCell {
    associatedtype T
    func configure(model: T)
}

final class NewEventDataSource<T: Equatable, V: NewEventCellViewModel, P:ConfigurableCell>: NSObject, UICollectionViewDataSource where P.T == V, V.T == T {
    
    private let offtenItems: [T]
    private var activeItemsViewModels: [V] = [V]()
    private let multipleSelection: Bool
    private let selectAction: ((_ items: [T]) -> Void)?
    
    private var selectedItems: [T] {
        return activeItemsViewModels.filter({ $0.isSelected }).map({ $0.model })
    }
    
    init(offtenItems: [T], multipleSelection: Bool, selectAction: ((_ items: [T]) -> Void)?) {
        self.offtenItems = offtenItems
        self.multipleSelection = multipleSelection
        self.selectAction = selectAction
        super.init()
        self.setupViewModels(items: offtenItems, selected: false)
        if !multipleSelection, let firstItem = offtenItems.first {
            self.setItemSelected(true, item: firstItem)
        }
    }
    
    func setupViewModels(items: [T], selected: Bool) {
        activeItemsViewModels = items.map({ item -> V in
            V(model: item, selectAction: { [weak self] (isSelected) in
                self?.setItemSelected(isSelected, item: item)
            })
        })
        selectAction?(selectedItems)
    }
    
    private func setItemSelected(_ isSelected: Bool, item: T) {
        if !multipleSelection && !isSelected { return }
        guard let index = activeItemsViewModels.firstIndex(where: { $0.model == item }) else { return }
        if !multipleSelection {
            activeItemsViewModels = activeItemsViewModels.map({
                var item = $0
                item.isSelected = false
                return item
            })
        }
        var viewModel = activeItemsViewModels[index]
        viewModel.isSelected = isSelected
        activeItemsViewModels[index] = viewModel
        selectAction?(selectedItems)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activeItemsViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.newEventGameCell.identifier, for: indexPath)
        if let cell = cell as? P {
            cell.configure(model: activeItemsViewModels[indexPath.row])
        }
        cell.layoutIfNeeded()
        return cell
    }
}

