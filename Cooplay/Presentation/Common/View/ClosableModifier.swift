//
//  ClosableModifier.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ClosableModifier: ViewModifier {
    
    @State private var canContinueDrag = true
    @State private var opacity: Double = 0
    @State private var scale: Double = 1
    private let anchor: UnitPoint
    private let closeHandler: (() -> Void)?
    
    init(anchor: UnitPoint, closeHandler: (() -> Void)?) {
        self.closeHandler = closeHandler
        self.anchor = anchor
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Color(.block)
                .cornerRadius(16)
                .opacity(opacity)
            content
        }
        .scaleEffect(scale, anchor: anchor)
        .contentShape(Rectangle())
        .simultaneousGesture(DragGesture()
            .onChanged({ gesture in
                if gesture.startLocation.x < CGFloat(20.0) && canContinueDrag {
                    let diff = gesture.location.x - gesture.startLocation.x
                    scale = 1 - diff / (anchor == .center ? 800 : 1000)
                    opacity = diff / 500
                    if diff >= 100 {
                        canContinueDrag = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            
                            withAnimation(.easeIn(duration: 0.2)) {
                                opacity = 0
                                scale = 1
                            }
                            Haptic.play(style: .medium)
                            closeHandler?()
                        }
                    }
                }
            })
                .onEnded({ _ in
                    canContinueDrag = true
                    withAnimation(.easeIn(duration: 0.2)) {
                        scale = 1
                        opacity = 0
                    }
                })
        )
    }
}

extension View {
    func closable(anchor: UnitPoint = .center, closeHandler: (() -> Void)?) -> some View {
        self.modifier(ClosableModifier(anchor: anchor, closeHandler: closeHandler))
    }
}
