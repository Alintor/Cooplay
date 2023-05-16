//
//  InvitationsHeaderCellViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 11/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import iCarousel

struct InvitationsHeaderCellViewModel {
    
    let dataSource: iCarouselDataSource
    let selectionAction: ((_ index: Int) -> Void)?
    
    init(dataSource: iCarouselDataSource, selectionAction: ((_ index: Int) -> Void)?) {
        self.dataSource = dataSource
        self.selectionAction = selectionAction
    }
}
