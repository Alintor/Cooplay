//
//  TimeCarouselItemView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

class TimeCarouselItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        self.backgroundColor = R.color.shapeBackground()
    }
    
    func configure(with model: TimeCarouselItemModel) {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        let line1 = UIView(frame: .zero)
        line1.layer.cornerRadius = 0.5
        line1.backgroundColor = model.prevDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        let line2 = UIView(frame: .zero)
        line2.layer.cornerRadius = 0.5
        line2.backgroundColor = model.prevDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        let lineBig = UIView(frame: .zero)
        lineBig.layer.cornerRadius = 0.5
        lineBig.backgroundColor = model.isDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        let line3 = UIView(frame: .zero)
        line3.layer.cornerRadius = 0.5
        line3.backgroundColor = model.nextDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        let line4 = UIView(frame: .zero)
        line4.layer.cornerRadius = 0.5
        line4.backgroundColor = model.nextDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        let line5 = UIView(frame: .zero)
        line5.layer.cornerRadius = 0.5
        line5.backgroundColor = model.nextDisable ? R.color.textSecondary()?.withAlphaComponent(0.2) : R.color.textSecondary()
        line1.translatesAutoresizingMaskIntoConstraints = false
        line2.translatesAutoresizingMaskIntoConstraints = false
        lineBig.translatesAutoresizingMaskIntoConstraints = false
        line3.translatesAutoresizingMaskIntoConstraints = false
        line4.translatesAutoresizingMaskIntoConstraints = false
        line5.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(line1)
        self.addSubview(line2)
        self.addSubview(lineBig)
        self.addSubview(line3)
        self.addSubview(line4)
        self.addSubview(line5)
        NSLayoutConstraint.activate([
            line1.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            line1.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            line1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            line1.widthAnchor.constraint(equalToConstant: 1),
            
            line2.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            line2.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            line2.leadingAnchor.constraint(equalTo: line1.trailingAnchor, constant: 3),
            line2.widthAnchor.constraint(equalToConstant: 1),
            
            lineBig.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            lineBig.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: model.isBig ? -8 : -16),
            lineBig.leadingAnchor.constraint(equalTo: line2.trailingAnchor, constant: 3),
            lineBig.widthAnchor.constraint(equalToConstant: 1),
            
            line3.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            line3.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            line3.leadingAnchor.constraint(equalTo: lineBig.trailingAnchor, constant: 3),
            line3.widthAnchor.constraint(equalToConstant: 1),
            
            line4.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            line4.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            line4.leadingAnchor.constraint(equalTo: line3.trailingAnchor, constant: 3),
            line4.widthAnchor.constraint(equalToConstant: 1),
            
            line5.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            line5.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            line5.leadingAnchor.constraint(equalTo: line4.trailingAnchor, constant: 3),
            line5.widthAnchor.constraint(equalToConstant: 1),
            line5.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

