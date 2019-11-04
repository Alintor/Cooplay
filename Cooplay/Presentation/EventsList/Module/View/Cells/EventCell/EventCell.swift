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
    
    static let defaultHeight: CGFloat = 126
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var lateTimeLabel: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusIconView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var membersView: UIStackView!
    @IBOutlet weak var statusIconWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        statusView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        guard selected && !isHighlighted else { return }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    
    @objc func statusTapped() {
        let stateContextView = StatusContextView(contextType: .overTarget, delegate: self, handler: nil)
        stateContextView.showMenu(size: .small, type: .statuses(type: .agreement, actionHandler: nil))
    }
    
    
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
        statusIconWidthConstraint?.isActive = model.lateTime == nil
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

extension EventCell: StatusContextDelegate {
    
    var targetView: UIView {
        return statusView
    }
    
    func restoreView(with menuItem: MenuItem?) {
        guard let status = menuItem?.value as? User.Status else { return }
        self.statusIconWidthConstraint?.isActive = status.lateTime == nil
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.statusTitle.text = status.title(isShort: true)
            self.lateTimeLabel.text = status.lateTimeString
            self.statusIconImageView.image = status.icon(isSmall: true)
            self.statusIconView.backgroundColor = status.color
            self.layoutIfNeeded()
        })
    }
}
