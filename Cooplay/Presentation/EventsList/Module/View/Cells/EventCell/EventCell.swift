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
    
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        statusView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        guard selected && !isHighlighted else { return }
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    
    @objc func statusTapped() {
        statusAction?(self)
    }
    
    
}

extension EventCell: ModelTransfer {
    
    func update(with model: EventCellViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        if let imagePath = model.imagePath {
            gameImageView.setImage(withPath: imagePath, placeholder: R.image.commonGameCover())
        } else {
            gameImageView.image = R.image.commonGameCover()
        }
        statusTitle.text = model.statusTitle
        lateTimeLabel.text = model.lateTime
        statusIconImageView.image = model.statusIcon
        statusIconView.backgroundColor = model.statusColor
        statusIconWidthConstraint?.isActive = model.lateTime == nil
        self.statusAction = model.statusAction
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
        guard let event = menuItem?.value as? Event, let status = event.me.status else { return }
        self.statusIconWidthConstraint?.isActive = status.details == nil
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.statusTitle.text = status.title(isShort: true, event: event)
            self.lateTimeLabel.text = status.detailsString
            self.statusIconImageView.image = status.icon(isSmall: true)
            self.statusIconView.backgroundColor = status.color
            self.layoutIfNeeded()
        })
    }
}
