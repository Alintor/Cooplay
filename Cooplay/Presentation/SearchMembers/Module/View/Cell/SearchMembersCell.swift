//
//  SearchMembersCell.swift
//  Cooplay
//
//  Created by Alexandr on 20/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class SearchMembersCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    
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
        guard animate else {
            configureStatus()
            completion?()
            return
        }
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.configureStatus()
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.isUserInteractionEnabled = true
            completion?()
        })
    }
    
    private func configureStatus() {
        if isMemberSelected {
            statusView.layer.borderColor = R.color.actionAccent()?.cgColor
            statusView.backgroundColor = R.color.actionAccent()
            statusImageView.isHidden = false
        } else {
            statusView.layer.borderColor = R.color.textSecondary()?.cgColor
            statusView.backgroundColor = R.color.background()
            statusImageView.isHidden = true
        }
    }
}

extension SearchMembersCell: ModelTransfer {

    func update(with model: SearchMembersCellViewModel) {
        self.isUserInteractionEnabled = true
        avatarView.update(with: model.avatarViewModel)
        nameLabel.text = model.name
        self.selectAction = model.selectionHandler
        isMemberSelected = model.isSelected
        setupState(animate: false, completion: nil)
    }
}
