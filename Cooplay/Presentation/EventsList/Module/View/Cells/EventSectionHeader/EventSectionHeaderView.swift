//
//  EventSectionHeaderView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 26/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage


class EventSectionHeaderView: UITableViewHeaderFooterView {
    
    var titleLabel: UILabel
    var isFirstDrawing = true
    
    override init(reuseIdentifier: String?) {
        titleLabel = UILabel(frame: .zero)
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = R.color.textSecondary()
        self.backgroundColor = R.color.background()
        self.tintColor = R.color.background()
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isFirstDrawing else { return }
        isFirstDrawing = false
        self.transform = CGAffineTransform(translationX: -rect.size.width, y: 0)
        self.backgroundColor = .clear
        self.tintColor = .clear
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { _ in
            self.backgroundColor = R.color.background()
            self.tintColor = R.color.background()
        }
    }
}

extension EventSectionHeaderView: ModelTransfer {

    func update(with model: String) {
        titleLabel.text = model
    }
}
