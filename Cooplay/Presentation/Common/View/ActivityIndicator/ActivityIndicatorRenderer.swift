//
//  ActivityIndicatorRenderer.swift
//  Cooplay
//
//  Created by Alexandr on 25/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

private enum ActivityIndicatorRendererConstant {
    
    static let viewTag = 13246
}

protocol ActivityIndicatorView: class {
    
    func start()
    func stop()
    
    func addToView(_ view: UIView)
}

extension ActivityIndicatorView where Self: UIView {
    
    func addToView(_ view: UIView) {
        self.tag = ActivityIndicatorRendererConstant.viewTag
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 3)
        ])
    }
}

enum ActivityIndicatorType {
    
    case arrows
    
    var view: ActivityIndicatorView {
        switch self {
        case .arrows:
            return ArrowsActivityIndicatorView()
        }
    }
}

protocol ActivityIndicatorRenderer {
    
    func showProgress(indicatorType: ActivityIndicatorType)
    func hideProgress()
}

extension ActivityIndicatorRenderer where Self: UIViewController {
    
    
    
    func showProgress(indicatorType: ActivityIndicatorType = .arrows) {
        view.isUserInteractionEnabled = false
        let activityView = indicatorType.view
        activityView.addToView(view)
        view.layoutIfNeeded()
        activityView.start()
        
    }
    
    func hideProgress() {
        view.isUserInteractionEnabled = true
        if let activityView = view.viewWithTag(ActivityIndicatorRendererConstant.viewTag) {
            if let activityView = activityView as? ActivityIndicatorView {
                activityView.stop()
            }
            activityView.removeFromSuperview()
        }
    }
}
