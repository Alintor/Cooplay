//
//  ReactionContextMenuView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

protocol ReactionContextMenuDelegate: AnyObject {
    
    var targetViewGlobalPoint: CGPoint { get }
    var targetViewSize: CGSize { get }
    var targetViewCopy: UIView? { get }
    var contextViewSize: CGSize? { get }
    var contextViewCopy: UIView? { get }
    func setContextView(hide: Bool)
}

class ReactionContextMenuView: UIView {
    
    // MARK: - Subviews
    
    private var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var menuBlockView = UIView().with {
        $0.backgroundColor = R.color.block()
        $0.layer.cornerRadius = 29
    }
    private var itemsStackView = UIStackView().with {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    private var additionalReactionsView = UIButton().with {
        $0.backgroundColor = R.color.block()
        $0.layer.cornerRadius = 15
    }
    private var additionalReactionsImageView = UIImageView().with {
        $0.image = R.image.commonDetails()
        $0.tintColor = R.color.textSecondary()
        $0.contentMode = .scaleAspectFit
    }
    private var targetView: UIView?
    private var contextView: UIView?
    
    // MARK: - Properties
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private weak var delegate: ReactionContextMenuDelegate?
    private var handler: ((_ reaction: Reaction?) -> Void)?
    private var selectedReaction: Reaction?
    private var isLeading: Bool = true
    
    private var reactions: [String] {
        let defaultsStorages = ApplicationAssembly.assembler.resolver.resolve(DefaultsStorageType.self)
        return defaultsStorages?.get(valueForKey: .reactions) as? [String] ?? GlobalConstant.defaultsReactions
    }
    
    // MARK: - Init
    
    init(
        delegate: ReactionContextMenuDelegate?,
        selectedReaction: Reaction?,
        handler: ((_ reaction: Reaction?) -> Void)?
    ) {
        self.delegate = delegate
        self.selectedReaction = selectedReaction
        self.handler = handler
        super.init(frame: .zero)
        setupView()
        layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        guard
            let window = topWindow,
            let delegate = delegate,
            let targetView = delegate.targetViewCopy,
            delegate.targetViewGlobalPoint != .zero
        else { return }
        self.targetView = targetView
        self.contextView = delegate.contextViewCopy
        self.frame = window.frame
        blurEffectView.frame = self.frame
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurEffectView)
        targetView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
        targetView.frame.origin = delegate.targetViewGlobalPoint
        targetView.translatesAutoresizingMaskIntoConstraints = false
        itemsStackView.translatesAutoresizingMaskIntoConstraints = false
        menuBlockView.translatesAutoresizingMaskIntoConstraints = false
        additionalReactionsView.translatesAutoresizingMaskIntoConstraints = false
        additionalReactionsView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTapAdditionalReactionsButton)
        ))
        additionalReactionsImageView.translatesAutoresizingMaskIntoConstraints = false
        menuBlockView.addSubview(itemsStackView)
        self.addSubview(blurEffectView)
        self.addSubview(targetView)
        self.addSubview(additionalReactionsView)
        additionalReactionsView.addSubview(additionalReactionsImageView)
        self.addSubview(menuBlockView)
        if let contextView = contextView {
            self.addSubview(contextView)
        }
        configureItems()
    }
    
    private func layout() {
        guard let window = topWindow, let targetView = targetView, let delegate = delegate else { return }
        
        let menuViewXConstraint: NSLayoutConstraint
        let additionalReactionsViewXConstraint: NSLayoutConstraint
        let leftEdgeDistance = targetView.frame.origin.x
        let rightEdgeDistance = window.frame.size.width - (targetView.frame.origin.x + targetView.frame.size.width)
        let imageViewIndent: CGFloat
        if leftEdgeDistance > rightEdgeDistance {
            isLeading = false
            menuViewXConstraint = menuBlockView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor, constant: 8)
            additionalReactionsViewXConstraint = additionalReactionsView.trailingAnchor.constraint(
                equalTo: targetView.leadingAnchor,
                constant: -4
            )
            additionalReactionsView.layer.cornerRadius = 20
            imageViewIndent = 8
        } else {
            isLeading = true
            menuViewXConstraint = menuBlockView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor, constant: -8)
            additionalReactionsViewXConstraint = additionalReactionsView.leadingAnchor.constraint(
                equalTo: targetView.trailingAnchor,
                constant: 4
            )
            additionalReactionsView.layer.cornerRadius = 15
            imageViewIndent = 3
        }
        
        NSLayoutConstraint.activate([
            targetView.topAnchor.constraint(equalTo: self.topAnchor, constant: delegate.targetViewGlobalPoint.y),
            targetView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: delegate.targetViewGlobalPoint.x),
            itemsStackView.topAnchor.constraint(equalTo: menuBlockView.topAnchor, constant: 8),
            itemsStackView.leadingAnchor.constraint(equalTo: menuBlockView.leadingAnchor, constant: 16),
            itemsStackView.trailingAnchor.constraint(equalTo: menuBlockView.trailingAnchor, constant: -16),
            itemsStackView.bottomAnchor.constraint(equalTo: menuBlockView.bottomAnchor, constant: -4),
            menuViewXConstraint,
            menuBlockView.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: -4),
            additionalReactionsViewXConstraint,
            additionalReactionsView.centerYAnchor.constraint(equalTo: targetView.centerYAnchor),
            additionalReactionsView.heightAnchor.constraint(equalToConstant: targetView.frame.size.height),
            additionalReactionsView.widthAnchor.constraint(equalToConstant: targetView.frame.size.height * 1.2),
            additionalReactionsImageView.leadingAnchor.constraint(
                equalTo: additionalReactionsView.leadingAnchor,
                constant: imageViewIndent
            ),
            additionalReactionsImageView.topAnchor.constraint(
                equalTo: additionalReactionsView.topAnchor,
                constant: imageViewIndent
            ),
            additionalReactionsImageView.trailingAnchor.constraint(
                equalTo: additionalReactionsView.trailingAnchor,
                constant: imageViewIndent * -1
            ),
            additionalReactionsImageView.bottomAnchor.constraint(
                equalTo: additionalReactionsView.bottomAnchor,
                constant: imageViewIndent * -1
            )
        ])
        if let contextView = contextView, let contextViewSize = delegate.contextViewSize {
            NSLayoutConstraint.activate([
                contextView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
                contextView.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: -4),
                contextView.heightAnchor.constraint(equalToConstant: contextViewSize.height),
                contextView.widthAnchor.constraint(equalToConstant: contextViewSize.width)
            ])
        }
    }
    
    private func configureItems() {
        for reaction in reactions {
            let item = ReactionContextMenuItemView(frame: .zero)
            item.setValue(reaction)
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemTapped)))
            item.showDot(selectedReaction?.value == reaction)
            itemsStackView.addArrangedSubview(item)
        }
    }
    
    private func clearSelection() {
        for subview in itemsStackView.arrangedSubviews {
            guard let item = subview as? ReactionContextMenuItemView else { continue }
            item.showDot(false)
        }
    }
    
    @objc private func closeTapped() {
        close(completion: nil)
    }
    
    @objc private func itemTapped(sender: UIGestureRecognizer) {
        guard
            let item = sender.view as? ReactionContextMenuItemView,
            let value = item.value
        else { return }
        clearSelection()
        item.showDot(true)
        close { [weak self] in
            if self?.selectedReaction?.value == value {
                self?.handler?(nil)
            } else {
                self?.handler?(Reaction(style: .emoji, value: value))
            }
        }
    }
    
    private func close(withImpact: Bool = true, completion: (()-> Void)? = nil) {
        generator.prepare()
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.menuBlockView.transform = CGAffineTransform(translationX: self.isLeading ? -100 : 100, y: 50).scaledBy(x: 0.1, y: 0.1)
            self.additionalReactionsView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.contextView?.transform = .identity
            self.menuBlockView.alpha = 0
            self.blurEffectView.alpha = 0
            self.additionalReactionsView.alpha = 0
        } completion: { _ in
            if withImpact {
                self.generator.impactOccurred()
            }
            self.delegate?.setContextView(hide: false)
            completion?()
            self.removeFromSuperview()
        }
    }
    
    @objc private func didTapAdditionalReactionsButton() {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        let additionalReactionsViewController = AdditionalReactionsBuilder().build(
            selectedReaction: selectedReaction?.value,
            handler: handler
        )
        if #available(iOS 15.0, *) {
            let sheet = additionalReactionsViewController.sheetPresentationController
            sheet?.detents = [.medium(), .large()]
            sheet?.prefersGrabberVisible = true
        }

        rootViewController?.presentModally(additionalReactionsViewController)
        UIView.animate(withDuration: 0.15) {
            self.targetView?.alpha = 0
        }
        close(withImpact: false)
    }
    
    // MARK: - Interface
    
    func show() {
        guard let window = topWindow, targetView != nil else { return }
        delegate?.setContextView(hide: true)
        menuBlockView.transform = CGAffineTransform(translationX: self.isLeading ? -100 : 100, y: 50).scaledBy(x: 0.1, y: 0)
        additionalReactionsView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        menuBlockView.alpha = 0
        additionalReactionsView.alpha = 0
        blurEffectView.alpha = 0
        window.addSubview(self)
        generator.prepare()
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.menuBlockView.transform = .identity
            self.additionalReactionsView.transform = .identity
            self.contextView?.transform = CGAffineTransform(translationX: 0, y: -60)
            self.menuBlockView.alpha = 1
            self.additionalReactionsView.alpha = 1
            self.blurEffectView.alpha = 1
        } completion: { _ in
            self.generator.impactOccurred()
        }
    }
    
}
