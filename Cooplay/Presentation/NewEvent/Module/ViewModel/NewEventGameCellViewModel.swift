//
//  NewEventGameCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct NewEventGameCellViewModel: NewEventCellViewModel {
    
    let coverPath: String
    var isSelected: Bool
    let selectAction: ((_ isSelected: Bool) -> Void)?
    
    let model: Game
    
    init(model: Game, selectAction: ((_ isSelected: Bool) -> Void)?) {
        self.model = model
        self.selectAction = selectAction
        coverPath = model.coverPath
        isSelected = false
    }
}
