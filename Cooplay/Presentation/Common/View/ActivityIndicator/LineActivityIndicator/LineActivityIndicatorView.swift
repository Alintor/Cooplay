//
//  LineActivityIndicatorView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 26.07.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

final class LineActivityIndicatorView: UIView {
    
    var skeletonViews: [UIView]?
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineActivityIndicatorView: ActivityIndicatorView {
    
    func addToView(_ view: UIView, needIndent: Bool) {
        guard view.viewWithTag(ActivityIndicatorRendererConstant.viewTag) == nil else { return }
        self.tag = ActivityIndicatorRendererConstant.viewTag
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func start() {
        self.showSkeleton(color: SkeletonGradient(baseColor: UIColor.clear, secondaryColor: UIColor.white.withAlphaComponent(0.3)), animation: SkeletonAnimation(direction: .leftRight, duration: 1.5))
    }
    
    func stop() {
        self.hideSkeleton()
    }
}

extension LineActivityIndicatorView: Skeletonable {
    
    var targetViews: [(view: UIView, cornerRadius: CGFloat)] {
        return [(self, 0)]
    }
    
}
