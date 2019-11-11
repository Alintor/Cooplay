//
//  EventSectionСollapsibleHeaderViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 11/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct EventSectionСollapsibleHeaderViewModel {
    
    let title: String
    let itemsCount: Int
    let showItems: Bool
    let toggleAction: (() -> Void)?
    
    init(title: String, itemsCount: Int, showItems: Bool, toggleAction: (() -> Void)?) {
        self.title = title
        self.itemsCount = itemsCount
        self.showItems = showItems
        self.toggleAction = toggleAction
    }
}
