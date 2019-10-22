//
//  MemberStatusView.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

@IBDesignable final class MemberStatusView: UIView {
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lateTimeLabel: UILabel!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var statusWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusTrailingConstrant: NSLayoutConstraint!
    
    private var view: UIView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNIB()
    }
    
    // MARK: - Interface
    
    func update(with model: MemberStatusViewModel) {
        avatarView.frame = view.frame
        avatarView.update(with: model)
        let diameter = view.frame.size.height * (7/16)
        statusIconImageView.image = model.statusIcon
        lateTimeLabel.text = model.lateTime
        statusWidthConstraint.isActive = model.lateTime == nil
        statusView.backgroundColor = model.statusColor
        lateTimeLabel.font = lateTimeLabel.font.withSize(diameter / 1.5)
        statusView.layer.cornerRadius = diameter / 2
        statusView.layer.borderWidth = diameter / 7
        statusView.layer.borderColor = model.borderColor?.cgColor
        statusBottomConstraint.constant = -(diameter / 7)
        statusTrailingConstrant.constant = -(diameter / 7) * 2
    }
    
    private func loadNIB() {
        view = R.nib.memberStatusView.firstView(owner: self)
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
    
}
