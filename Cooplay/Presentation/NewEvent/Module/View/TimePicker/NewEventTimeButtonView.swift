//
//  NewEventTimeButtonView.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit


final class NewEventTimeButtonView: UIView, Skeletonable {
    
    var timeLabel: UILabel!
    var iconView: UIView!
    var iconImageView: UIImageView!
    var arrowImageView: UIImageView!
    
    var skeletonView: UIView?
    
    var targetView: UIView {
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        backgroundColor = R.color.block()
        layer.cornerRadius = 12
        timeLabel = UILabel(frame: .zero)
        timeLabel.font = UIFont.systemFont(ofSize: 20)
        timeLabel.textColor = R.color.textPrimary()
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView = UIImageView(image: R.image.commonArrowDown())
        arrowImageView.tintColor = R.color.textPrimary()
        arrowImageView.contentMode = .scaleAspectFit
        self.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        iconView = UIView(frame: .zero)
        iconView.backgroundColor = R.color.actionAccent()
        iconView.layer.cornerRadius = 12
        self.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView = UIImageView(image: R.image.statusNormalLate())
        iconImageView.tintColor = R.color.block()
        iconView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconImageView.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0),
            iconImageView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0),
            iconImageView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: 0),
            iconImageView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 0),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            arrowImageView.widthAnchor.constraint(equalToConstant: 10),
            arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor),
            arrowImageView.trailingAnchor.constraint(lessThanOrEqualTo: iconView.leadingAnchor, constant: -8),
            arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    func setTime(_ date: Date) {
        self.hideSkeleton()
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        timeLabel.text = timeFormatter.string(from: date)
    }
}
