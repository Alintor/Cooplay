//
//  Event+extensions.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

extension Event {
    
    var statusesType: StatusMenuItem.StatusesType {
        return !isAgreed ? .agreement : (isActive ? .confirmation : .agreement)
    }
    
}
