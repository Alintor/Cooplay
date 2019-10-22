//
//  ActiveEventCell.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class ActiveEventCell: UITableViewCell {

    static let defaultHeight: CGFloat = 225
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var membersView: UIStackView!
    @IBOutlet weak var blockView: UIView!
    
}

extension ActiveEventCell: ModelTransfer {
    
    func update(with model: ActiveEventCellViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        gameImageView.setImage(withPath: model.imagePath)
        statusTitle.text = model.statusTitle
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
        let avatarDiameter = membersView.frame.size.height
        membersView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for member in model.members {
            let avatarView = MemberStatusView(
                frame: CGRect(x: 0, y: 0, width: avatarDiameter, height: avatarDiameter)
            )
            member.borderColor = blockView.backgroundColor
            avatarView.update(with: member)
            NSLayoutConstraint.activate([
                avatarView.heightAnchor.constraint(equalToConstant: avatarDiameter),
                avatarView.widthAnchor.constraint(equalToConstant: avatarDiameter)
                ])
            membersView.addArrangedSubview(avatarView)
        }
        if let otherCount = model.otherCount {
            let avatarView = AvatarView(
                frame: CGRect(x: 0, y: 0, width: avatarDiameter, height: avatarDiameter)
            )
            avatarView.update(with: otherCount)
            NSLayoutConstraint.activate([
                avatarView.heightAnchor.constraint(equalToConstant: avatarDiameter),
                avatarView.widthAnchor.constraint(equalToConstant: avatarDiameter)
                ])
            membersView.addArrangedSubview(avatarView)
        }
    }
}


