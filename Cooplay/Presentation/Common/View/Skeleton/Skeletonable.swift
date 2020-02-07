//
//  Skeletonable.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol Skeletonable: class {
    
    var skeletonViews: [UIView]? { get set }
    var targetViews: [(view: UIView, cornerRadius: CGFloat)] { get }
    func showSkeleton(color: SkeletonGradient, animation: SkeletonAnimation)
    func hideSkeleton()
    func prepereView()
    func restoreView()
}

extension Skeletonable {
    
    func prepereView() {}
    func restoreView() {}
}

extension Skeletonable {
    
    func showSkeleton(color: SkeletonGradient, animation: SkeletonAnimation) {
        prepereView()
        skeletonViews = []
        for targetView in targetViews {
            let skeletonView = UIView(frame: targetView.view.bounds)
            skeletonView.layer.cornerRadius = targetView.cornerRadius
            targetView.view.addSubview(skeletonView)
            let gradient = CAGradientLayer(layer: skeletonView.layer)
            gradient.colors = color.colors
            gradient.startPoint = animation.direction.startPoint().to
            gradient.endPoint = animation.direction.endPoint().to
            gradient.frame = skeletonView.bounds
            gradient.cornerRadius = targetView.cornerRadius
            skeletonView.layer.insertSublayer(gradient, at: 0)
            skeletonViews?.append(skeletonView)
            gradient.add(animation.animation, forKey: nil)
        }
        
    }
    
    func hideSkeleton() {
        guard let skeletonViews = skeletonViews else { return }
        for skeletonView in skeletonViews {
            skeletonView.layer.removeAllAnimations()
            skeletonView.removeFromSuperview()
        }
        self.skeletonViews = nil
        restoreView()
    }
}
