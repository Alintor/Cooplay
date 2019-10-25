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
        if let lateness = model.lateness {
            lateTime = "\(lateness)"
        }
        if let status = model.status {
            statusIcon = UIImage(named: "status.small.\(status.rawValue)")
            statusColor = UIColor(named: "status.\(status.rawValue)")
        }
    }
    
}
