//
//  TimeCarouselItemModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftDate

struct TimeCarouselItemModel {
    
    let value: Int
    let sizeType: TimeCarouselConfiguration.SizeType
    let isDisable: Bool
    let nextDisable: Bool
    let prevDisable: Bool
    let startDate: Date
    
    var isBig: Bool {
        sizeType.isBig
    }
}
