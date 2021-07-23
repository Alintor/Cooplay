//
//  EventDetailsMemberCell.swift
//  Cooplay
//
//  Created by Alexandr on 16/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class EventDetailsMemberCell: UITableViewCell {
    
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var latenessLabel: UILabel!
    @IBOutlet weak var ownerIconImageView: UIImageView!
    @IBOutlet weak var statusDetailsView: UIView!
    @IBOutlet weak var statusDetailsBlockView: UIView!
    
    @IBOutlet weak var blockLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var blockTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarLeadingContraint: NSLayoutConstraint!
    @IBOutlet weak var statusTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        statusDetailsBlockView.roundCorners(topLeft: 4, topRight: 15, bottomLeft: 15, bottomRight: 15)
    }
}

extension EventDetailsMemberCell: ModelTransfer {

    func update(with model: EventDetailsCellViewModel) {
        nameLabel.text = model.name
        latenessLabel.text = model.lateness
        statusDetailsBlockView.layer.mask = nil
        statusDetailsView.isHidden = model.lateness == nil
        statusView.backgroundColor = model.statusColor
        statusImageView.image = model.statusIcon
        avatarView.update(with: model.avatarViewModel)
        ownerIconImageView.isHidden = !model.isOwner
        lineHeightConstraint.constant = 0.5
    }
}

extension EventDetailsMemberCell: StatusContextDelegate {
    var targetView: UIView {
        return blockView
    }
    
    func prepareView(completion: @escaping () -> Void) {
        blockLeadingConstraint.constant = 11
        blockTrailingConstraint.constant = 10
        avatarLeadingContraint.constant = 14
        statusTrailingConstraint.constant = 14
        UIView.animate(withDuration: 0.1, animations: {
            self.blockView.layer.cornerRadius = 12
            self.blockView.backgroundColor = R.color.block()
            self.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }
    
    func restoreView(with menuItem: MenuItem?) {
        blockLeadingConstraint.constant = 0
        blockTrailingConstraint.constant = 0
        avatarLeadingContraint.constant = 24
        statusTrailingConstraint.constant = 24
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.blockView.layer.cornerRadius = 0
            self.blockView.backgroundColor = R.color.background()
            self.layoutIfNeeded()
        })
    }
    
}
