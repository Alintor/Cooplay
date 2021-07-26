//
//  MemberStatusViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

final class MemberStatusViewModel: AvatarViewModel {
    
    var statusColor: UIColor?
    var statusIcon: UIImage?
    var lateTime: String?
    var borderColor: UIColor?
    
    override init(with model: User) {
        super.init(with: model)
        lateTime = model.status?.detailsString
        statusIcon = model.status?.icon(isSmall: true)
        statusColor = model.status?.color
    }
    
}
