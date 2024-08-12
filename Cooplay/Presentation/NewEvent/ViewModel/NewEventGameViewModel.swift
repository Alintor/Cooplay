//
//  NewEventGameCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct NewEventGameViewModel: Equatable {

    let coverPath: String?
    var isSelected: Bool
    
    let model: Game
    
    init(model: Game, isSelected: Bool) {
        self.model = model
        coverPath = model.coverPath
        self.isSelected = isSelected
    }
    
    static func == (lhs: NewEventGameViewModel, rhs: NewEventGameViewModel) -> Bool {
        lhs.model == rhs.model && lhs.isSelected == rhs.isSelected
    }
    
}
