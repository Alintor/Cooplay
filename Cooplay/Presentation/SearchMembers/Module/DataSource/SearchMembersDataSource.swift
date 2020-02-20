//
//  SearchMembersDataSource.swift
//  Cooplay
//
//  Created by Alexandr on 19/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

final class SearchMembersDataSource: NSObject {
    
    private(set) var items: [User]
    private let selectAction: (() -> Void)?
    
    init(with items: [User], selectAction: (() -> Void)?) {
        self.items = items
        self.selectAction = selectAction
    }
    
    func addItem(_ item: User) {
        guard items.firstIndex(where: { $0 == item }) == nil else { return }
        items.append(item)
    }
    
    func removeItem(_ item: User) {
        guard let index = items.firstIndex(where: { $0 == item }) else { return }
        items.remove(at: index)
    }
}

extension SearchMembersDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewEventMemberCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? NewEventMemberCell {
            let item = items[indexPath.row]
            cell.configure(model: NewEventMemberCellViewModel(
                model: item,
                isSelected: true,
                selectAction: { [weak self] (_) in
                    self?.removeItem(item)
                    self?.selectAction?()
                }
            ))
        }
        return cell
    }
    
    
}
