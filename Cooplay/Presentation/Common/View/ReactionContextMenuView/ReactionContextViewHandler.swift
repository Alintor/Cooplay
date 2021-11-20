//
//  ReactionContextViewHandler.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class ReactionContextViewHandler: ObservableObject {
    
    enum ViewCornerType {
        case square
        case circle
        case rounded(value: CGFloat)
    }
    
    let viewCornerType: ViewCornerType
    var hideView: ((_ hide: Bool) -> Void)?
    @Published var isViewHidden: Bool = false
    
    init(viewCornerType: ViewCornerType) {
        self.viewCornerType = viewCornerType
    }
    
    var viewRect: CGRect = CGRect() {
        didSet {
            if viewRect.origin.x < 0 || viewRect.origin.y < 0 {
                viewRect = oldValue
            }
        }
    }
}

extension ReactionContextViewHandler: GeometryGetterDelegate {
    
    func setRect(_ rect: CGRect) { viewRect = rect }
}
