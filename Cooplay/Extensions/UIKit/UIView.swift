//
//  UIKit.swift
//  Cooplay
//
//  Created by Alexandr on 24/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIView {
    
    enum LinePosition {
        
        case top
        case bottom
        case left
        case right
    }
    
    func addLine(color: UIColor?, height: CGFloat, position: LinePosition) {
        let line = UIView(frame: .zero)
        line.backgroundColor = color
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: self.topAnchor),
                line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                line.heightAnchor.constraint(equalToConstant: height)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                line.heightAnchor.constraint(equalToConstant: height)
            ])
        case .left:
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                line.topAnchor.constraint(equalTo: self.topAnchor),
                line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                line.widthAnchor.constraint(equalToConstant: height)
            ])
        case .right:
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                line.topAnchor.constraint(equalTo: self.topAnchor),
                line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                line.widthAnchor.constraint(equalToConstant: height)
            ])
        }
    }
    
}
