//
//  StateContextViewHandler.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import Combine
import UIKit

class ContextMenuHandler: ObservableObject {
    
    enum ViewCornerType {
        case square
        case circle
        case rounded(value: CGFloat)
    }
    
    let viewCornerType: ViewCornerType
    var completion: ((_ item: MenuItem?) -> Void)?
    var hideTargetView: ((_ hide: Bool) -> Void)?
    
    init(viewCornerType: ViewCornerType) {
        self.viewCornerType = viewCornerType
    }
    
    private var viewFrame: CGRect = CGRect() {
        didSet {
            if viewFrame.origin.x < 0 || viewFrame.origin.y < 0 {
                viewFrame = oldValue
            }
        }
    }
    private var imageView: UIImageView? = nil
    
    private var topWindow: UIWindow? {
       for window in UIApplication.shared.windows.reversed() {
           if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
       }
       return nil
   }
    
    func takeSnaphot() {
        imageView = UIImageView(image: topWindow?.asImage(rect: CGRect(origin: targetViewGlobalPoint, size: targetViewSize)))
    }
    
    
    
}

extension ContextMenuHandler: GeometryGetterDelegate {
    
    func setRect(_ rect: CGRect) { viewFrame = rect }
}

extension ContextMenuHandler: StatusContextDelegate {
    
    var targetView: UIView { UIView() }
    
    var targetViewGlobalPoint: CGPoint { return viewFrame.origin }
    
    var targetViewSize: CGSize { return viewFrame.size }
    
    var targetViewCopy: UIView? {
        imageView?.frame = CGRect(origin: targetViewGlobalPoint, size: targetViewSize)
        imageView?.clipsToBounds = true
        switch viewCornerType {
        case .circle: imageView?.layer.cornerRadius = targetViewSize.height / 2
        case .rounded(let value): imageView?.layer.cornerRadius = value
        case .square: break
        }
        return imageView
    }
    
    func setTargetView(hide: Bool) {
        hideTargetView?(hide)
    }
    
    func restoreView(with menuItem: MenuItem?) {
        completion?(menuItem)
    }
}

extension ContextMenuHandler: TimeCarouselContextDelegate {
    
    var targetButtonView: UIView { UIView() }
}
