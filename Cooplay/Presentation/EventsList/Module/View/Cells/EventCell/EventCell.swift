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
    
    static let defaultHeight: CGFloat = 114
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var lateTimeLabel: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var membersView: UIStackView!
    @IBOutlet weak var statusIconWidthConstraint: NSLayoutConstraint!
    
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
        statusIconWidthConstraint.isActive = model.lateTime == nil
        let avatarDiameter = membersView.frame.size.height
        membersView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for member in model.members {
            let avatarView = AvatarView(
                frame: CGRect(x: 0, y: 0, width: avatarDiameter, height: avatarDiameter)
            )
            avatarView.update(with: member)
            NSLayoutConstraint.activate([
                avatarView.heightAnchor.constraint(equalToConstant: avatarDiameter),
                avatarView.widthAnchor.constraint(equalToConstant: avatarDiameter)
            ])
            membersView.addArrangedSubview(avatarView)
        }
    }
}
