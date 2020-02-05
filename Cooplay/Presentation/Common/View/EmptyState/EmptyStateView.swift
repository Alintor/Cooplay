//
//  EmptyStateView.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

final class EmptyStateView: UIView {
    
    private enum Constant {
        
        static let spacing: CGFloat = 24
        static let indent: CGFloat = 16
    }
    
    var view: UIView!
    var stackView: UIStackView!
    var imageView: UIImageView!
    var textView: UIView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    func update(with model: EmptyStateHandler) {
        let image = model.image(forEmptyDataSet: nil)
        imageView.image = image
        imageView.isHidden = image == nil
        titleLabel.attributedText = model.attributedTitle
        descriptionLabel.attributedText = model.attributedDescription
    }
    
    func configureView() {
        configureTextView()
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView = UIStackView(arrangedSubviews: [imageView, textView])
        stackView.axis = .vertical
        stackView.spacing = Constant.spacing
        stackView.alignment = .center
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView!.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            imageView!.heightAnchor.constraint(equalTo: imageView!.widthAnchor, multiplier: 1),
            stackView!.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -Constant.indent),
            stackView!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.indent),
            stackView!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.indent)
        ])
    }
    
    private func configureTextView() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        textView = UIView(frame: .zero)
        textView.addSubview(titleLabel)
        textView.addSubview(descriptionLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel!.topAnchor.constraint(equalTo: textView!.topAnchor, constant: 0),
            titleLabel!.leadingAnchor.constraint(equalTo: textView!.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: textView!.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel!.topAnchor, constant: -Constant.indent),
            descriptionLabel!.leadingAnchor.constraint(equalTo: textView!.leadingAnchor, constant: 0),
            descriptionLabel!.trailingAnchor.constraint(equalTo: textView!.trailingAnchor, constant: 0),
            descriptionLabel!.bottomAnchor.constraint(equalTo: textView!.bottomAnchor, constant: 0)
        ])
    }
}
