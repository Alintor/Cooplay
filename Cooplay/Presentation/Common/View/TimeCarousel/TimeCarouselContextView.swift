//
//  TimeCarouselContextView.swift
//  Cooplay
//
//  Created by Alexandr on 18/01/2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

protocol TimeCarouselContextDelegate: class {
    
    var targetButtonView: UIView { get }
}

extension TimeCarouselContextDelegate {
    
    var targetViewGlobalPoint: CGPoint {
        return targetButtonView.superview?.convert(targetButtonView.frame.origin, to: nil) ?? targetButtonView.frame.origin
    }
    
    var targetViewSize: CGSize {
        return targetButtonView.frame.size
    }
    
    var targetViewCopy: UIView? {
        return targetButtonView.snapshotView(afterScreenUpdates: true)
    }
}

final class TimeCarouselContextView: UIView {
    
    @objc class var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var timePanel: TimeCarouselPanel
    private var panelTransform: CGAffineTransform
    
    init(configuration: TimeCarouselConfiguration, delegate: TimeCarouselContextDelegate?, selectHandler: ((_ date: Date) -> Void)?) {
        timePanel = TimeCarouselPanel(configuration: configuration)
        panelTransform = CGAffineTransform(scaleX: 0.85, y: 0.85).translatedBy(x: 0, y: -80)
        super.init(frame: .zero)
        guard
            let window = TimeCarouselContextView.topWindow,
            let delegate = delegate,
            let targetView = delegate.targetViewCopy
        else { return }
        self.frame = window.frame
        blurEffectView.frame = self.frame
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(emptyViewTapped))
        targetView.addGestureRecognizer(tapGestureRecognizer2)
        targetView.frame.origin = delegate.targetViewGlobalPoint
        timePanel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timePanel)
        self.addSubview(targetView)
        NSLayoutConstraint.activate([
            timePanel.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 8),
            timePanel.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            timePanel.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
            timePanel.heightAnchor.constraint(equalToConstant: 191)
        ])
        timePanel.transform = panelTransform
        timePanel.alpha = 0
        timePanel.cancelHandler = { [weak self] in
            self?.close(completion: nil)
        }
        timePanel.confirmHandler = { [weak self] in
            self?.close {
                if let date = self?.timePanel.date {
                    selectHandler?(date)
                }
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emptyViewTapped))
        blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        timePanel.loadData()
        timePanel.clipsToBounds = true
        timePanel.layer.cornerRadius = 12
    }
    
    func show() {
        guard let window = TimeCarouselContextView.topWindow else { return }
        window.addSubview(self)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.timePanel.transform = .identity
            self.timePanel.alpha = 1
            self.blurEffectView.alpha = 1
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func emptyViewTapped() {
        close(completion: nil)
    }
    
    func close(completion: (()-> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.timePanel.transform = self.panelTransform
                self.blurEffectView.alpha = 0
                self.timePanel.alpha = 0
                
            },
            completion: { _ in
                generator.impactOccurred()
                completion?()
                self.removeFromSuperview()
            }
        )
    }
    
}
