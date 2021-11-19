//
//  ReactionContextMenuHandler.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

class ReactionContextMenuHandler {
    
    enum ViewCornerType {
        case square
        case circle
        case rounded(value: CGFloat)
    }
    
    let viewCornerType: ViewCornerType
    weak var contextViewHandler: ReactionContextViewHandler?
    
    init(viewCornerType: ViewCornerType, contextViewHandler: ReactionContextViewHandler?) {
        self.viewCornerType = viewCornerType
        self.contextViewHandler = contextViewHandler
    }
    
    private var viewRect: CGRect = CGRect() {
        didSet {
            if viewRect.origin.x < 0 || viewRect.origin.y < 0 {
                viewRect = oldValue
            }
        }
    }
    private var targetImageView: UIImageView? = nil
    private var contextImageView: UIImageView? = nil
    
    private var topWindow: UIWindow? {
       for window in UIApplication.shared.windows.reversed() {
           if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
       }
       return nil
   }
    
    func takeSnaphot() {
        targetImageView = UIImageView(image: topWindow?.asImage(rect: viewRect))
        if let contextViewRect = contextViewHandler?.viewRect {
            contextImageView = UIImageView(image: topWindow?.asImage(rect: contextViewRect))
        }
    }
    
}

extension ReactionContextMenuHandler: ReactionContextMenuDelegate {
    
    var targetViewGlobalPoint: CGPoint { viewRect.origin }
    
    var targetViewSize: CGSize { viewRect.size }
    
    var targetViewCopy: UIView? {
        targetImageView?.frame = viewRect
        targetImageView?.clipsToBounds = true
        switch viewCornerType {
        case .circle: targetImageView?.layer.cornerRadius = targetViewSize.height / 2
        case .rounded(let value): targetImageView?.layer.cornerRadius = value
        case .square: break
        }
        return targetImageView
    }
    
    var contextViewSize: CGSize? { contextViewHandler?.viewRect.size }
    
    var contextViewCopy: UIView? {
        guard let rect = contextViewHandler?.viewRect else { return nil }
        contextImageView?.frame = rect
        contextImageView?.clipsToBounds = true
        switch contextViewHandler?.viewCornerType {
        case .circle: contextImageView?.layer.cornerRadius = targetViewSize.height / 2
        case .rounded(let value): contextImageView?.layer.cornerRadius = value
        case .square, .none: break
        }
        return contextImageView
    }
    
    func setContextView(hide: Bool) {
        contextViewHandler?.hideView?(hide)
    }
}

extension ReactionContextMenuHandler: GeometryGetterDelegate {
    
    func setRect(_ rect: CGRect) { viewRect = rect }
}
