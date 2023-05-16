//
//  NewEventCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

protocol NewEventCellViewModel {
    
    associatedtype T
    
    var prevState: Bool? { get set }
    var isSelected: Bool { get set }
    var selectAction: ((_ isSelected: Bool) -> Void)? { get }
    var model: T { get }
    init(model: T, isSelected: Bool, selectAction: ((_ isSelected: Bool) -> Void)?)
}
