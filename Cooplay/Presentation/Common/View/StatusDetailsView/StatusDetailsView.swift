//
//  StatusDetailsView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 26.07.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

class StatusDetailsView: UIView {
    
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        self.backgroundColor = .clear
        let textView = UIView(frame: .zero)
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = R.color.textPrimary()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(titleLabel)
        
        subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.textColor = R.color.textSecondary()
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(subtitleLabel)
        
        self.addSubview(textView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            subtitleLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 0),
            subtitleLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0),
            subtitleLabel.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            textView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 0),
            textView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: 0)
        ])
    }
    
    func update(with model: StatusDetailsViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}
