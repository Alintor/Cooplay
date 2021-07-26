//
//  ActivityIndicatorRenderer.swift
//  Cooplay
//
//  Created by Alexandr on 25/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

enum ActivityIndicatorRendererConstant {
    
    static let viewTag = 13246
    static let backgroundTag = 43632352
}

protocol ActivityIndicatorView: class {
    
    func start()
    func stop()
    
    func addToView(_ view: UIView, needIndent: Bool)
}

extension ActivityIndicatorView where Self: UIView {
    
    func addToView(_ view: UIView, needIndent: Bool) {
        self.tag = ActivityIndicatorRendererConstant.viewTag
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / (needIndent ? 2.5 : 2))
        ])
    }
}

enum ActivityIndicatorType {
    
    case arrows
    case line
    
    var view: ActivityIndicatorView {
        switch self {
        case .arrows:
            return ArrowsActivityIndicatorView()
        case .line:
            return LineActivityIndicatorView()
        }
    }
    
    var needBackground: Bool {
        switch self {
        case .line:
            return false
        default:
            return true
        }
    }
}

protocol ActivityIndicatorRenderer {
    
    func showProgress(indicatorType: ActivityIndicatorType, fullScreen: Bool)
    func hideProgress()
    var activityIndicatorTargetView: UIView? { get }
}

extension ActivityIndicatorRenderer {
    
    var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    var activityIndicatorTargetView: UIView? {
        return (self as? UIViewController)?.view
    }
    
    func showProgress(indicatorType: ActivityIndicatorType = .arrows, fullScreen: Bool = true) {
        let targetView: UIView? = fullScreen ? topWindow : self.activityIndicatorTargetView
        guard let view = targetView else { return }
        let activityView = indicatorType.view
        if indicatorType.needBackground {
            let backgroundView = UIView(frame: view.bounds)
            backgroundView.backgroundColor = R.color.background()?.withAlphaComponent(0.9)
            backgroundView.tag = ActivityIndicatorRendererConstant.backgroundTag
            view.addSubview(backgroundView)
        }
        activityView.addToView(view, needIndent: !fullScreen)
        view.layoutIfNeeded()
        activityView.start()
        
    }
    
    func hideProgress() {
        let targetViews: [UIView?] = [topWindow, self.activityIndicatorTargetView]
        for view in targetViews {
            if let activityView = view?.viewWithTag(ActivityIndicatorRendererConstant.viewTag) {
                if let activityView = activityView as? ActivityIndicatorView {
                    activityView.stop()
                }
                activityView.removeFromSuperview()
            }
            if let backgroundView = view?.viewWithTag(ActivityIndicatorRendererConstant.backgroundTag) {
                backgroundView.removeFromSuperview()
            }
        }
    }
}
