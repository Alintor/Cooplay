//
//  UITableView.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

extension UITableView {
    
    var lastRowIndexPath: IndexPath {
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfRows(inSection: lastSectionIndex) - 1
        return IndexPath(row: lastRowIndex, section: lastSectionIndex)
    }
    
    var isEmpty: Bool {
        var totalRows: Int = 0
        guard numberOfSections > 0 else { return true }
        for section in 0...(numberOfSections - 1) {
            totalRows += numberOfRows(inSection: section)
        }
        return totalRows == 0
    }
    
    func reloadEmptyState(_ emptyState: EmptyStateHandler?) {
        self.isScrollEnabled = !isEmpty
        if let emptyState = emptyState, isEmpty {
            setEmptyState(emptyState)
        } else {
            clearEmptyState()
        }
    }
    
    func setEmptyState(_ emptyState: EmptyStateHandler) {
        let emptyView = EmptyStateView(
            frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        )
        emptyView.update(with: emptyState)
        self.backgroundView = emptyView
        self.layoutSubviews()
    }
    
    func clearEmptyState() {
        self.backgroundView = nil
    }
}
