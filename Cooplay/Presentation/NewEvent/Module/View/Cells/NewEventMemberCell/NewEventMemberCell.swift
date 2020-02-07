//
//  NewEventMemberCell.swift
//  Cooplay
//
//  Created by Alexandr on 07/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

class NewEventMemberCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarBlockView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var statusBlockView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var avatarViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarViewTrailingConstraint: NSLayoutConstraint!
    
    var isMemberSelected: Bool = false
    var selectAction: ((_ isSelected: Bool) -> Void)?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        isMemberSelected = !isMemberSelected
        setupState(animate: true) {
            self.selectAction?(self.isMemberSelected)
        }
    }
    
    private func setupState(animate: Bool, completion: (() -> Void)?) {
        if isSelected {
            avatarViewTopConstraint.constant = -4
            avatarViewBottomConstraint.constant = 4
            avatarViewLeadingConstraint.constant = -4
            avatarViewTrailingConstraint.constant = 4
        } else {
            avatarViewTopConstraint.constant = 0
            avatarViewBottomConstraint.constant = 0
            avatarViewLeadingConstraint.constant = 0
            avatarViewTrailingConstraint.constant = 0
        }
        guard animate else {
            configureStatus()
            completion?()
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.configureStatus()
            self.layoutIfNeeded()
        }, completion: { (_) in
            completion?()
        })
    }
    
    private func configureStatus() {
        if isMemberSelected {
            nameLabel.textColor = R.color.textPrimary()
            avatarBlockView.layer.borderWidth = 2
            avatarBlockView.layer.borderColor = R.color.actionAccent()?.cgColor
            avatarView.backgroundView.layer.cornerRadius = 22
            avatarView.alpha = 0.9
            statusView.layer.borderColor = R.color.actionAccent()?.cgColor
            statusView.backgroundColor = R.color.actionAccent()
            statusImageView.isHidden = false
        } else {
            nameLabel.textColor = R.color.textSecondary()
            avatarBlockView.layer.borderWidth = 0
            avatarBlockView.layer.borderColor = UIColor.clear.cgColor
            avatarView.backgroundView.layer.cornerRadius = 26
            avatarView.alpha = 1
            statusView.layer.borderColor = R.color.textSecondary()?.cgColor
            statusView.backgroundColor = R.color.background()
            statusImageView.isHidden = true
        }
    }

}

extension NewEventMemberCell: ConfigurableCell {
    typealias T = NewEventMemberCellViewModel
    
    func configure(model: NewEventMemberCellViewModel) {
        nameLabel.text = model.name
        avatarView.update(with: model.avatarViewModel)
        self.selectAction = model.selectAction
        isMemberSelected = model.isSelected
        setupState(animate: false, completion: nil)
    }
    
    static var reuseIdentifier: String {
        return R.reuseIdentifier.newEventMemberCell.identifier
    }
}
