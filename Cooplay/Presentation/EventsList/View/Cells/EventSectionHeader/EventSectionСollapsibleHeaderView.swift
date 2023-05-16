//
//  EventSectionСollapsibleHeaderView.swift
//  Cooplay
//
//  Created by Alexandr on 11/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class EventSectionСollapsibleHeaderView: UITableViewHeaderFooterView {
    
    var titleLabel: UILabel
    var itemsCountLabel: UILabel
    var arrowImageView: UIImageView
    var isFirstDrawing = true
    var toggleAction: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        titleLabel = UILabel(frame: .zero)
        itemsCountLabel = UILabel(frame: .zero)
        arrowImageView = UIImageView(image: R.image.commonArrowDown())
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = R.color.textSecondary()
        itemsCountLabel.font = UIFont.systemFont(ofSize: 17)
        itemsCountLabel.textColor = R.color.textPrimary()
        arrowImageView.tintColor = R.color.textSecondary()
        self.backgroundColor = .clear
        self.tintColor = .clear
        let backgroundView = UIView(frame: self.frame)
        backgroundView.backgroundColor = R.color.background()
        self.backgroundView = backgroundView
        self.addSubview(titleLabel)
        self.addSubview(itemsCountLabel)
        self.addSubview(arrowImageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: itemsCountLabel.leadingAnchor, constant: -6),
            itemsCountLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            itemsCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -6),
            arrowImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard isFirstDrawing else { return }
        isFirstDrawing = false
        self.transform = CGAffineTransform(translationX: -rect.size.width, y: 0)
        self.backgroundView?.backgroundColor = .clear
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { _ in
            self.backgroundView?.backgroundColor = R.color.background()
        }
    }
    
    @objc func tapAction() {
        guard !arrowImageView.isHidden else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }) { (_) in
            self.toggleAction?()
        }
    }
    
    
}

extension EventSectionСollapsibleHeaderView: ModelTransfer {

    func update(with model: EventSectionСollapsibleHeaderViewModel) {
        titleLabel.text = model.title
        if let itemsCount = model.itemsCount {
            itemsCountLabel.text = "\(itemsCount)"
        } else {
            itemsCountLabel.text = nil
        }
        self.toggleAction = model.toggleAction
        arrowImageView.isHidden = model.toggleAction == nil
        arrowImageView.transform = .identity
        arrowImageView.image = model.showItems ? R.image.commonArrowDown() : R.image.commonArrowUp()
    }
}
