//
//  MemberStatusView.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

@IBDesignable final class MemberStatusView: UIView {
    
    private enum Constant {
        
        static let size = CGSize(width: 48, height: 40)
        static let fontSize: CGFloat = 9
        static let statusViewSize = CGSize(width: 16, height: 16)
        static let statusBorder: CGFloat = 2
        static let textVerticalIndent: CGFloat = 3
        static let textHorizontalIndent: CGFloat = 3
        static let statusViewCornerRadius: CGFloat = 8
        static let statusBorderCornerRadius: CGFloat = 10
    }
    
    private let avatarView: AvatarView
    private let statusView: UIView
    private let lateTimeLabel: UILabel
    private let statusIconImageView: UIImageView
    private let statusBorderView: UIView
    private let statusWidthConstraint: NSLayoutConstraint
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        avatarView = AvatarView(frame: CGRect(x: 0, y: 0, width: Constant.size.height, height: Constant.size.height))
        statusView = UIView(frame: .zero)
        lateTimeLabel = UILabel(frame: .zero)
        statusIconImageView = UIImageView(frame: .zero)
        statusBorderView = UIView(frame: .zero)
        statusWidthConstraint = statusView.widthAnchor.constraint(equalTo: statusView.heightAnchor)
        super.init(frame: frame)
        //loadNIB()
        
        lateTimeLabel.font = UIFont.systemFont(ofSize: Constant.fontSize, weight: .bold)
        lateTimeLabel.textAlignment = .center
        statusBorderView.layer.cornerRadius = Constant.statusBorderCornerRadius
        statusView.layer.cornerRadius = Constant.statusViewCornerRadius
        
        self.addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: self.topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            avatarView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor)
        ])
        statusView.addSubview(statusIconImageView)
        statusView.addSubview(lateTimeLabel)
        statusIconImageView.translatesAutoresizingMaskIntoConstraints = false
        lateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusIconImageView.topAnchor.constraint(equalTo: statusView.topAnchor),
            statusIconImageView.bottomAnchor.constraint(equalTo: statusView.bottomAnchor),
            statusIconImageView.leadingAnchor.constraint(equalTo: statusView.leadingAnchor),
            statusIconImageView.trailingAnchor.constraint(equalTo: statusView.trailingAnchor),
            lateTimeLabel.topAnchor.constraint(equalTo: statusView.topAnchor, constant: Constant.textVerticalIndent),
            lateTimeLabel.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -Constant.textVerticalIndent),
            lateTimeLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: Constant.textHorizontalIndent),
            lateTimeLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -Constant.textHorizontalIndent)
        ])
        statusBorderView.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.heightAnchor.constraint(equalToConstant: Constant.statusViewSize.height),
            statusWidthConstraint,
            statusView.topAnchor.constraint(equalTo: statusBorderView.topAnchor, constant: Constant.statusBorder),
            statusView.bottomAnchor.constraint(equalTo: statusBorderView.bottomAnchor, constant: -Constant.statusBorder),
            statusView.leadingAnchor.constraint(equalTo: statusBorderView.leadingAnchor, constant: Constant.statusBorder),
            statusView.trailingAnchor.constraint(equalTo: statusBorderView.trailingAnchor, constant: -Constant.statusBorder)
        ])
        self.addSubview(statusBorderView)
        statusBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constant.statusBorder),
            statusBorderView.leadingAnchor.constraint(equalTo: self.centerXAnchor),
            self.heightAnchor.constraint(equalToConstant: Constant.size.height),
            self.widthAnchor.constraint(equalToConstant: Constant.size.width)
        ])
        
    }
    
    
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    
    convenience init(with model: MemberStatusViewModel) {
        self.init(frame: CGRect(origin: .zero, size: Constant.size))
        avatarView.update(with: model)
        self.backgroundColor = .clear
        statusBorderView.backgroundColor = model.borderColor
        statusView.backgroundColor = model.statusColor
        statusIconImageView.image = model.statusIcon
        statusIconImageView.tintColor = model.borderColor
        lateTimeLabel.text = model.lateTime
        lateTimeLabel.textColor = model.borderColor
        statusWidthConstraint.isActive = model.lateTime == nil
        
    }
}
