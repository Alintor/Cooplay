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
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusViewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        statusView.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        
        // handle touch down and touch up events separately
        if gesture.state == .began {
            print(statusView.frame)
            UIView.animate(withDuration: 0.1) {
                self.statusView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
            
        } else if  gesture.state == .ended {
            let touchLocation = gesture.location(in: statusView)
            print(touchLocation)
            print(statusView.frame)
            if touchLocation.x >= 0 && touchLocation.x <= (statusView.frame.width / 0.95) && touchLocation.y > 0 && touchLocation.y <= (statusView.frame.height / 0.95) {
                UIView.animate(withDuration: 0.1) {
                    self.statusView.transform = .identity
                }
                
                let stateContextView = StatusContextView(contextType: .moveToBottom, delegate: self, handler: nil)
                stateContextView.showMenu(size: .large, type: .confirmation)
            } else {
                UIView.animate(withDuration: 0.1) {
                    self.statusView.transform = .identity
                }
            }
            
        }
    }
    
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

extension ActiveEventCell: StatusContextDelegate {
    
    var targetView: UIView {
        return statusView
    }
    
    func transformTargetView(_ tranform: Bool) {
        if tranform {
            statusViewLeadingConstraint.constant = 0
            statusViewTrailingConstraint.constant = 0
            statusView.layer.cornerRadius = 12
        } else {
            statusViewLeadingConstraint.constant = 16
            statusViewTrailingConstraint.constant = 16
            statusView.layer.cornerRadius = 8
        }
    }
    
    func prepareView(completion: @escaping () -> Void) {
        statusViewLeadingConstraint.constant = 0
        statusViewTrailingConstraint.constant = 0
        statusView.layer.cornerRadius = 12
        UIView.animate(withDuration: 0.1, animations: {
            self.statusView.layer.cornerRadius = 12
            self.statusView.backgroundColor = R.color.block()
            self.layoutIfNeeded()
        }) { (_) in
            completion()
        }
    }
    
    func restoreView() {
        statusViewLeadingConstraint.constant = 16
        statusViewTrailingConstraint.constant = 16
        UIView.animate(withDuration: 0.1) {
            self.statusView.layer.cornerRadius = 8
            self.statusView.backgroundColor = R.color.shapeBackground()
            self.layoutIfNeeded()
        }
    }
}

