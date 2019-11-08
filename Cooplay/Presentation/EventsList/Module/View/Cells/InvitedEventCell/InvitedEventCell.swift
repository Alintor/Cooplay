//
//  InvitedEventCell.swift
//  Cooplay
//
//  Created by Alexandr on 06/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

final class InvitedEventCell: UIView {
    
    enum Constant {
        
        static let size = CGSize(width: 355, height: 110)
        static let smallSize = CGSize(width: 345, height: 110)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var actionsView: UIView!
    @IBOutlet weak var membersView: UIStackView!
    
    var statusAction: ((_ delegate: StatusContextDelegate?) -> Void)?
    
    private var view: UIView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNIB()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(actionsTapped))
        actionsView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(isSmall: Bool) {
        self.init(frame: CGRect(origin: .zero, size: isSmall ? Constant.smallSize : Constant.size))
    }
    
    
    @objc func actionsTapped() {
        statusAction?(self)
    }
    
    // MARK: - Interface
    
    func update(with model: EventCellViewModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date
        gameImageView.setImage(withPath: model.imagePath)
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
    
    // MARK: - Private
    
    private func loadNIB() {
        view = R.nib.invitedEventCell(owner: self)
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
}

extension InvitedEventCell: StatusContextDelegate {

    var targetView: UIView {
        return actionsView
    }
}
