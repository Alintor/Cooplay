//
//  TimeCarouselPanelView.swift
//  Cooplay
//
//  Created by Alexandr on 13.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct TimeCarouselPanelView: UIViewRepresentable {
    
    let configuration: TimeCarouselConfiguration
    let cancelHandler: (() -> Void)?
    let confirmHandler: ((_ status: User.Status) -> Void)?
    
    func makeUIView(context: Context) -> UIView {
        let timeCarouselPanel = TimeCarouselPanel(configuration: configuration)
        timeCarouselPanel.cancelHandler = cancelHandler
        timeCarouselPanel.statusHandler = confirmHandler
        timeCarouselPanel.backgroundColor = R.color.shapeBackground()
        timeCarouselPanel.loadData()
        return timeCarouselPanel
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}
