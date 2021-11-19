//
//  ReactionContextMenuItemView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

class ReactionContextMenuItemView: UIView {
    
    // MARK: - Subviews
    
    private let valueLabel = UILabel().with {
        $0.font = .systemFont(ofSize: 31)
    }
    private let dotView = UIView(frame: .zero).with {
        $0.backgroundColor = R.color.textSecondary()
        $0.layer.cornerRadius = 2
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        layout()
    }
    
    // MARK: - Private methods
    
    
    private func setupView() {
        self.backgroundColor = .clear
        dotView.isHidden = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        dotView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        addSubview(dotView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dotView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            dotView.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
            dotView.heightAnchor.constraint(equalToConstant: 4),
            dotView.widthAnchor.constraint(equalToConstant: 4),
            dotView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    // MARK: - Interface
    
    var value: String? {
        valueLabel.text
    }
    
    func setValue(_ value: String) {
        valueLabel.text = value
    }
    
    func showDot(_ show: Bool) {
        dotView.isHidden = !show
    }
}
