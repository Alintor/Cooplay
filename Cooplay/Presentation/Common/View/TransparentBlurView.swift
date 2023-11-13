//
//  TransparentBlurView.swift
//  Cooplay
//
//  Created by Alexandr on 12.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: . systemUltraThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removeAllFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll (where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
    
}
