//
//  StateContextMenuView.swift
//  Cooplay
//
//  Created by Alexandr on 22/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

class StatusMenuView: UIView {
    
    private enum Constant {
        
        static let latenessItems = [15, 30, 45, 60]
        static let lineColor = R.color.textSecondary()?.withAlphaComponent(0.6)
        static let lineHeight: CGFloat = 0.5
        static let latenessAnimateDuration: TimeInterval = 0.3
        static let selectionDuration: TimeInterval = 0.1
        static let latenessMovingBoard: CGFloat = 0.5
        static let itemEdgeIndent: CGFloat = 16
        static let iconIndent: CGFloat = 8
        static let iconHeight: CGFloat = 30
        
    }
    
    enum MenuType {
        
        case agreement
        case confirmation
        
        var items: [User.Status] {
            switch self {
            case .agreement:
                return User.Status.agreementStatuses
            case .confirmation:
                return User.Status.confirmationStatuses
            }
        }
    }
    
    enum MenuSize {
        
        case small
        case large
        
        var width: CGFloat {
            switch self {
            case .small:
                return UIScreen.main.bounds.width / 1.5
            case .large:
                return UIScreen.main.bounds.width - 20
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small:
                return 17
            case .large:
                return 20
            }
        }
        
        var itemHeight: CGFloat {
            switch self {
            case .small:
                return 44
            case .large:
                return 56
            }
        }
        
        var backgroundColor: UIColor? {
            switch self {
            case .small:
                return R.color.block()?.withAlphaComponent(0.5)
            case .large:
                return R.color.block()
            }
        }
        
        var selectionColor: UIColor? {
            switch self {
            case .small:
                return R.color.block()?.withAlphaComponent(0.2)
            case .large:
                return R.color.block()?.withAlphaComponent(0.5)
            }
        }
        
        var cornerRadius: CGFloat {
            return 12
        }
    }
    
    // MARK: - Properties
    
    var acceptedItemView: UIView?
    var maybeItemView: UIView?
    var declinedItemView: UIView?
    var ontimeItemView: UIView?
    var lateItemView: UIView?
    var latenessItemView: UIView?
    
    var lateLeadingConstraint: NSLayoutConstraint?
    
    let itemsStackView = UIStackView(frame: .zero)
    let menuSize: MenuSize
    var handler: ((_ status: User.Status) -> Void)?
    
    // MARK: - Init
    
    init(size: MenuSize, type: MenuType, handler: ((_ status: User.Status) -> Void)?) {
        self.menuSize = size
        self.handler = handler
        super.init(frame: .zero)
        configureView()
        for item in type.items {
            addMenuItem(status: item)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureView() {
        self.backgroundColor = .clear
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = .clear
        backgroundView.clipsToBounds = true
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: menuSize.width)
        ])
        backgroundView.layer.cornerRadius = menuSize.cornerRadius
        backgroundView.addSubview(itemsStackView)
        itemsStackView.axis = .vertical
        itemsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemsStackView.clipsToBounds = true
        NSLayoutConstraint.activate([
            itemsStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            itemsStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            itemsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            itemsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor)
        ])
    }
    
    func addMenuItem(status: User.Status) {
        let itemView = UIView(frame: .zero)
        itemView.clipsToBounds = true
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: menuSize.fontSize)
        let imageView = UIImageView(frame: .zero)
        
        itemView.addSubview(titleLabel)
        itemView.addSubview(imageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: itemView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: Constant.iconIndent),
            titleLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: Constant.itemEdgeIndent),
            imageView.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -Constant.itemEdgeIndent),
            imageView.heightAnchor.constraint(equalToConstant: Constant.iconHeight),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            itemView.heightAnchor.constraint(equalToConstant: menuSize.itemHeight)
        ])
        titleLabel.text = status.title()
        imageView.image = status.icon()
        switch status {
        case .declined:
            titleLabel.textColor = R.color.red()
            imageView.tintColor = R.color.red()
        default:
            titleLabel.textColor = R.color.textPrimary()
            imageView.tintColor = R.color.textPrimary()
            itemView.addLine(color: Constant.lineColor, height: Constant.lineHeight, position: .bottom)
            
        }
        itemView.backgroundColor = menuSize.backgroundColor
        configureItem(itemView, status: status)
        itemView.sizeToFit()
    }
    
    private func configureItem(_ itemView: UIView, status: User.Status) {
        switch status {
        case .accepted:
            acceptedItemView = itemView
            itemsStackView.addArrangedSubview(itemView)
        case .ontime:
            ontimeItemView = itemView
            itemsStackView.addArrangedSubview(itemView)
        case .maybe:
            maybeItemView = itemView
            itemsStackView.addArrangedSubview(itemView)
        case .declined:
            declinedItemView = itemView
            itemsStackView.addArrangedSubview(itemView)
        case .late:
            lateItemView = itemView
            let latenessStackView = UIStackView(frame: .zero)
            latenessStackView.axis = .horizontal
            latenessStackView.alignment = .fill
            latenessStackView.distribution = .fillEqually
            latenessStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                latenessStackView.heightAnchor.constraint(equalToConstant: menuSize.itemHeight)
            ])
            for lateItem in Constant.latenessItems {
                let lateItemView = UIView(frame: .zero)
                lateItemView.backgroundColor = menuSize.backgroundColor
                let titleLabel = UILabel(frame: .zero)
                titleLabel.font = UIFont.systemFont(ofSize: menuSize.fontSize)
                titleLabel.textColor = R.color.textPrimary()
                titleLabel.textAlignment = .center
                titleLabel.text = "\(lateItem)"
                lateItemView.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: lateItemView.topAnchor),
                    titleLabel.bottomAnchor.constraint(equalTo: lateItemView.bottomAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: lateItemView.trailingAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: lateItemView.leadingAnchor)
                ])
                lateItemView.addLine(color: Constant.lineColor, height: Constant.lineHeight, position: .bottom)
                if lateItem != Constant.latenessItems.last {
                    lateItemView.addLine(color: Constant.lineColor, height: Constant.lineHeight, position: .right)
                }
                latenessStackView.addArrangedSubview(lateItemView)
                let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
                tapGestureRecognizer.minimumPressDuration = 0
                tapGestureRecognizer.delegate = self
                lateItemView.addGestureRecognizer(tapGestureRecognizer)
            }
            let latenessItemView = UIView(frame: .zero)
            latenessItemView.backgroundColor = .clear
            latenessItemView.addSubview(itemView)
            latenessItemView.addSubview(latenessStackView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            latenessStackView.translatesAutoresizingMaskIntoConstraints = false
            let lateLeadingConstraint = itemView.leadingAnchor.constraint(equalTo: latenessItemView.leadingAnchor)
            self.lateLeadingConstraint = lateLeadingConstraint
            itemsStackView.addArrangedSubview(latenessItemView)
            NSLayoutConstraint.activate([
                latenessItemView.widthAnchor.constraint(equalTo: self.widthAnchor),
                lateLeadingConstraint,
                latenessStackView.leadingAnchor.constraint(equalTo: itemView.trailingAnchor),
                itemView.widthAnchor.constraint(equalTo: latenessItemView.widthAnchor),
                latenessStackView.widthAnchor.constraint(equalTo: latenessItemView.widthAnchor),
                itemView.topAnchor.constraint(equalTo: latenessItemView.topAnchor),
                latenessStackView.topAnchor.constraint(equalTo: latenessItemView.topAnchor),
                itemView.bottomAnchor.constraint(equalTo: latenessItemView.bottomAnchor),
                latenessStackView.bottomAnchor.constraint(equalTo: latenessItemView.bottomAnchor)
            ])
            latenessItemView.addLine(color: Constant.lineColor, height: Constant.lineHeight, position: .bottom)
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
            panGestureRecognizer.delegate = self
            latenessItemView.addGestureRecognizer(panGestureRecognizer)
            self.latenessItemView = latenessItemView
        default: break
        }
        let tapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tapGestureRecognizer.minimumPressDuration = 0
        tapGestureRecognizer.delegate = self
        itemView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Gesture handlers
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        guard let itemView = gesture.view else { return }
        if gesture.state == .began {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            UIView.animate(withDuration: 0.1) {
                itemView.backgroundColor = self.menuSize.selectionColor
            }
        }
        if  gesture.state == .ended {
            if
                let lateLeadingConstraint = lateLeadingConstraint,
                lateLeadingConstraint.constant < 0 || lateLeadingConstraint.constant > -(menuSize.width + 10) {
                if abs(lateLeadingConstraint.constant) < menuSize.width * Constant.latenessMovingBoard {
                    lateLeadingConstraint.constant = 0
                } else {
                    lateLeadingConstraint.constant = -menuSize.width
                }
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                })
            }
            latenessItemView?.backgroundColor = .clear
            UIView.animate(withDuration: 0.1) {
                itemView.backgroundColor = self.menuSize.backgroundColor
            }
            let touchLocation = gesture.location(in: itemView)
            if touchLocation.x >= 0
                && touchLocation.x <= (itemView.frame.width)
                && touchLocation.y > 0
                && touchLocation.y <= (itemView.frame.height) {
                switch itemView {
                case acceptedItemView:
                    handler?(.accepted)
                case ontimeItemView:
                    handler?(.ontime)
                case maybeItemView:
                    handler?(.maybe)
                case declinedItemView:
                    handler?(.declined)
                case lateItemView:
                    lateLeadingConstraint?.constant = -menuSize.width
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                        self.layoutIfNeeded()
                    })
                default:
                    for subview in itemView.subviews {
                        guard
                            let label = subview as? UILabel,
                            let text = label.text,
                            let lateTime = Int(text)
                        else { continue }
                        handler?(.late(minutes: lateTime))
                    }
                }
            }
        }
    }
    
    @objc func panHandler(gesture: UIPanGestureRecognizer) {
        guard let itemView = gesture.view else { return }
        if gesture.state == .changed, let lateLeadingConstraint = lateLeadingConstraint, lateLeadingConstraint.constant < 0 {
            guard let targetView = latenessItemView else { return }
            let touchLocation = gesture.location(in: targetView)
            if touchLocation.x >= 0 && touchLocation.x <= (targetView.frame.width) && touchLocation.y > 0 && touchLocation.y <= (targetView.frame.height) {
                itemView.backgroundColor = self.menuSize.backgroundColor
                let translation = gesture.translation(in: targetView)
                let inset = -menuSize.width + translation.x
                if inset <= -menuSize.width {
                    gesture.state = .ended
                }
                if abs(inset) < menuSize.width * Constant.latenessMovingBoard || inset > 0 {
                    lateLeadingConstraint.constant = 0
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                        self.layoutIfNeeded()
                    })
                } else {
                    lateLeadingConstraint.constant = inset
                }
            } else {
                gesture.state = .ended
                if abs(lateLeadingConstraint.constant) < menuSize.width * Constant.latenessMovingBoard {
                    lateLeadingConstraint.constant = 0
                } else {
                    lateLeadingConstraint.constant = -menuSize.width
                }
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
}

extension StatusMenuView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer, panGestureRecognizer.translation(in: superview).x < 0 {
            return false
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}
