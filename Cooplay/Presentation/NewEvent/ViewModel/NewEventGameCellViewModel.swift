//
//  NewEventGameCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct NewEventGameCellViewModel: NewEventCellViewModel, Equatable {

    let coverPath: String?
    var isSelected: Bool
    var prevState: Bool?
    let selectAction: ((_ isSelected: Bool) -> Void)?
    
    let model: Game
    
    init(model: Game, isSelected: Bool, selectAction: ((_ isSelected: Bool) -> Void)?) {
        self.model = model
        self.selectAction = selectAction
        coverPath = model.coverPath
        self.isSelected = isSelected
    }
    
    static func == (lhs: NewEventGameCellViewModel, rhs: NewEventGameCellViewModel) -> Bool {
        lhs.model == rhs.model && lhs.isSelected == rhs.isSelected
    }
    
}
