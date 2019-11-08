//
//  ContextMenuRouter.swift
//  Cooplay
//
//  Created by Alexandr on 08/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation

protocol ContextMenuRouter {}

extension ContextMenuRouter {
    
    func showContextMenu(
        delegate: StatusContextDelegate?,
        contextType: StatusContextView.ContextType,
        menuSize: StatusMenuView.MenuSize,
        menuType: StatusMenuView.MenuType) {
        let contextMenuView = StatusContextView(contextType: contextType, delegate: delegate)
        contextMenuView.showMenu(size: menuSize, type: menuType)
    }
}
