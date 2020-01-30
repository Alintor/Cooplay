//
//  SkeletonAnimation.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

typealias SkeletonAnimationPoint = (from: CGPoint, to: CGPoint)

enum SkeletonAnimationtDirection {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    
    func startPoint(multipler: CGFloat = 1) -> SkeletonAnimationPoint {
        switch self {
        case .leftRight:
            return (from: CGPoint(x:-1 * multipler, y:0.5), to: CGPoint(x:1, y:0.5))
        case .rightLeft:
            return (from: CGPoint(x:1, y:0.5), to: CGPoint(x:-1 * multipler, y:0.5))
        case .topBottom:
            return (from: CGPoint(x:0.5, y:-1 * multipler), to: CGPoint(x:0.5, y:1))
        case .bottomTop:
            return (from: CGPoint(x:0.5, y:1), to: CGPoint(x:0.5, y:-1 * multipler))
        case .topLeftBottomRight:
            return (from: CGPoint(x:-1 * multipler, y:-1 * multipler), to: CGPoint(x:1, y:1))
        case .bottomRightTopLeft:
            return (from: CGPoint(x:1, y:1), to: CGPoint(x:-1 * multipler, y:-1 * multipler))
        }
    }
    
    func endPoint(multipler: CGFloat = 1) -> SkeletonAnimationPoint {
        switch self {
        case .leftRight:
            return (from: CGPoint(x:0, y:0.5), to: CGPoint(x:2 * multipler, y:0.5))
        case .rightLeft:
            return ( from: CGPoint(x:2 * multipler, y:0.5), to: CGPoint(x:0, y:0.5))
        case .topBottom:
            return ( from: CGPoint(x:0.5, y:0), to: CGPoint(x:0.5, y:2 * multipler))
        case .bottomTop:
            return ( from: CGPoint(x:0.5, y:2 * multipler), to: CGPoint(x:0.5, y:0))
        case .topLeftBottomRight:
            return ( from: CGPoint(x:0, y:0), to: CGPoint(x:2 * multipler, y:2 * multipler))
        case .bottomRightTopLeft:
            return ( from: CGPoint(x:2 * multipler, y:2 * multipler), to: CGPoint(x:0, y:0))
        }
    }
}

struct SkeletonAnimation {
    
    let animation: CAAnimation
    let direction: SkeletonAnimationtDirection
    
    init(direction: SkeletonAnimationtDirection, sizeMultiplier: CGFloat = 1, duration: CFTimeInterval, startDelay: CFTimeInterval = 0, intervalDelay: CFTimeInterval = 0) {
        self.direction = direction
        let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
        startPointAnim.fromValue = direction.startPoint(multipler: sizeMultiplier).from
        startPointAnim.toValue = direction.startPoint(multipler: sizeMultiplier).to
        
        let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
        endPointAnim.fromValue = direction.endPoint(multipler: sizeMultiplier).from
        endPointAnim.toValue = direction.endPoint(multipler: sizeMultiplier).to
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [startPointAnim, endPointAnim]
        animGroup.duration = duration
        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animGroup.fillMode = .forwards
        animGroup.isRemovedOnCompletion = false
        
        let superGroup = CAAnimationGroup()
        superGroup.animations = [animGroup]
        superGroup.duration = duration + intervalDelay
        superGroup.repeatCount = .infinity
        superGroup.beginTime = CACurrentMediaTime() + startDelay
        superGroup.isRemovedOnCompletion = false
        
        
        self.animation = superGroup
    }
}
