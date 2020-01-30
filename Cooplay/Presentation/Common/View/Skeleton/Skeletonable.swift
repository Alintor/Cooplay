//
//  Skeletonable.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol Skeletonable: class {
    
    var skeletonView: UIView? { get set }
    var targetView: UIView { get }
    func showSkeleton(color: SkeletonGradient, animation: SkeletonAnimation)
    func hideSkeleton()
}

extension Skeletonable {
    
    func showSkeleton(color: SkeletonGradient, animation: SkeletonAnimation) {
        let skeletonView = UIView(frame: targetView.bounds)
        skeletonView.layer.cornerRadius = targetView.layer.cornerRadius
        targetView.addSubview(skeletonView)
        let gradient = CAGradientLayer(layer: skeletonView.layer)
        gradient.colors = color.colors
        gradient.startPoint = animation.direction.startPoint().to
        gradient.endPoint = animation.direction.endPoint().to
        gradient.frame = skeletonView.bounds
        gradient.cornerRadius = targetView.layer.cornerRadius
        skeletonView.layer.insertSublayer(gradient, at: 0)
        self.skeletonView = skeletonView
        gradient.add(animation.animation, forKey: nil)
    }
    
    func hideSkeleton() {
        skeletonView?.layer.removeAllAnimations()
        skeletonView?.removeFromSuperview()
        skeletonView = nil
    }
}
