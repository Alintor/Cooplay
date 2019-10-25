//
//  StateContextView.swift
//  Cooplay
//
//  Created by Alexandr on 22/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

protocol StatusContextDelegate: class {
    
    var targetView: UIView { get }
    func prepareView(completion: @escaping () -> Void)
    func restoreView()
}

extension StatusContextDelegate {
    
    var targetViewGlobalPoint: CGPoint {
        return targetView.superview?.convert(targetView.frame.origin, to: nil) ?? targetView.frame.origin
    }
    
    var targetViewSize: CGSize {
        return targetView.frame.size
    }
    
    var targetViewCopy: UIView? {
        return targetView.snapshotView(afterScreenUpdates: true)
    }
    
    func setTargetView(hide: Bool) {
        targetView.isHidden = hide
    }
    
    func prepareView(completion: @escaping () -> Void) {
        completion()
    }
    
    func restoreView() {}
}

class StatusContextView: UIView {
    
    private enum Constant {
        
        static let menuAnimationScale: CGFloat = 0.8
        static let menuIndent: CGFloat = 8
    }
    
    enum ContextType {
        
        case moveToBottom
        case overTarget
        
        var delay: TimeInterval {
            switch self {
            case .overTarget:
                return 0
            case .moveToBottom:
                return 0.1
            }
        }
    }
    
    @objc class var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var menuView: StatusMenuView?
    private var targetView: UIView?
    private var menuViewYConstraint: NSLayoutConstraint?
    private var menuTransform: CGAffineTransform?
    private let contextType: ContextType
    private weak var delegate: StatusContextDelegate?
    private var handler: ((_ status: User.Status) -> Void)?
    
    init(contextType: ContextType, delegate: StatusContextDelegate?, handler: ((_ status: User.Status) -> Void)?) {
        self.contextType = contextType
        super.init(frame: .zero)
        self.delegate = delegate
        self.handler = handler
        guard let window = StatusContextView.topWindow else { return }
        self.frame = window.frame
        blurEffectView.frame = self.frame
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showMenu(size: StatusMenuView.MenuSize, type: StatusMenuView.MenuType) {
        guard let window = StatusContextView.topWindow else { return }
        window.addSubview(self)
        delegate?.prepareView {  [weak self] in
            self?.show(menuSize: size, menuType: type)
        }
    }
    
    private func show(menuSize: StatusMenuView.MenuSize, menuType: StatusMenuView.MenuType) {
        guard
            let window = StatusContextView.topWindow,
            let delegate = delegate,
            let targetView = delegate.targetViewCopy
        else { return }
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(close))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(close))
        blurEffectView.addGestureRecognizer(tapGestureRecognizer1)
        targetView.addGestureRecognizer(tapGestureRecognizer2)
        
        targetView.frame.origin = delegate.targetViewGlobalPoint
        self.targetView = targetView
        self.addSubview(targetView)
        
        let  menuView = StatusMenuView(size: menuSize, type: menuType) { [weak self] status in
            self?.handler?(status)
            self?.close()
        }
        self.menuView = menuView
        self.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        var menuViewXConstraint: NSLayoutConstraint
        var menuViewYConstraint: NSLayoutConstraint
        var menuTransform = CGAffineTransform(scaleX: Constant.menuAnimationScale, y: Constant.menuAnimationScale)
        switch contextType {
        case .moveToBottom:
            menuViewYConstraint = menuView.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: -Constant.menuIndent)
            menuViewXConstraint = menuView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            menuTransform = menuTransform.translatedBy(x: 0, y: targetView.frame.height)
        case .overTarget:
            switch menuSize {
            case .large:
                menuViewXConstraint = menuView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            case .small:
                let leftEdgeDistance = targetView.frame.origin.x
                let rightEdgeDistance = window.frame.size.width - (targetView.frame.origin.x + targetView.frame.size.width)
                if leftEdgeDistance > rightEdgeDistance {
                    menuViewXConstraint = menuView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor)
                    menuTransform = menuTransform.translatedBy(x: targetView.frame.height, y: 0)
                } else {
                    menuViewXConstraint = menuView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor)
                    menuTransform = menuTransform.translatedBy(x: -targetView.frame.height, y: 0)
                }
            }
            let topEdgeDistance = targetView.frame.origin.y
            let bottomEdgeDistance = window.frame.size.height - (targetView.frame.origin.y + targetView.frame.size.height)
            if topEdgeDistance > bottomEdgeDistance {
                menuViewYConstraint = menuView.bottomAnchor.constraint(equalTo: targetView.topAnchor, constant: -Constant.menuIndent)
                menuTransform = menuTransform.translatedBy(x: 0, y: targetView.frame.height)
            } else {
                menuViewYConstraint = menuView.topAnchor.constraint(equalTo: targetView.bottomAnchor, constant: 8)
                menuTransform = menuTransform.translatedBy(x: 0, y: -targetView.frame.height)
            }
        }
        self.menuViewYConstraint = menuViewYConstraint
        NSLayoutConstraint.activate([
            menuViewXConstraint,
            menuViewYConstraint
        ])
        
        menuView.transform = menuTransform
        self.menuTransform = menuTransform
        menuView.alpha = 0
        delegate.setTargetView(hide: true)
        
        UIView.animate(withDuration: 0.3, delay: contextType.delay, options: .curveEaseOut, animations: {
            self.menuView?.transform = .identity
            self.menuView?.alpha = 1
            //self.blurEffectView.alpha = 1
        })
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.blurEffectView.alpha = 1
            if self.contextType == .moveToBottom {
                targetView.frame.origin.y =
                    window.frame.height - window.safeAreaInsets.bottom - targetView.frame.height - Constant.menuIndent
            }
        })
    }
    
    @objc func close() {
        self.menuViewYConstraint?.isActive = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.menuView?.transform = self.menuTransform!
            self.menuView?.alpha = 0
            //self.blurEffectView.alpha = 0
        })
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.blurEffectView.alpha = 0
                guard let delegate = self.delegate, self.contextType == .moveToBottom else { return }
                self.targetView?.frame = CGRect(
                    origin: delegate.targetViewGlobalPoint,
                    size: delegate.targetViewSize
                )
            },
            completion: { _ in
                self.delegate?.restoreView()
                self.delegate?.setTargetView(hide: false)
                self.removeFromSuperview()
            }
        )
    }
}
