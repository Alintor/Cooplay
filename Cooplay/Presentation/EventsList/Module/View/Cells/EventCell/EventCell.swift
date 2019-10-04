//
//  EventCell.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class EventCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var lateTimeLabel: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var membersView: UIStackView!
    
}

extension EventCell: ModelTransfer {
    
    func update(with model: EventCellViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        gameImageView.setImage(withPath: model.imagePath)
        statusTitle.text = model.statusTitle
        lateTimeLabel.text = model.lateTime
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
        let avatarDiameter = membersView.frame.size.height
        let avatarCornerRadius = avatarDiameter / 2
        for member in model.members {
            let avatarView = AvatarView(
                frame: CGRect(x: 0, y: 0, width: avatarDiameter, height: avatarDiameter)
            )
            avatarView.layer.cornerRadius = avatarCornerRadius
            avatarView.update(with: member)
            membersView.addArrangedSubview(avatarView)
        }
    }
}
