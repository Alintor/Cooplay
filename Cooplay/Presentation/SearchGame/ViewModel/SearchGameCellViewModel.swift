//
//  SearchGameCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 04/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct SearchGameCellViewModel {
    
    let coverPath: String?
    let title: String
    let isSelected: Bool
    
    let model: Game
    
    init(with model: Game, isSelected: Bool) {
        self.model = model
        coverPath = model.coverPath
        title = model.name
        self.isSelected = isSelected
    }
}
