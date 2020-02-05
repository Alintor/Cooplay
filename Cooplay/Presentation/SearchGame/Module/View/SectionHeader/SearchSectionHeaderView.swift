//
//  SearchSectionHeaderView.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class SearchSectionHeaderView: UITableViewHeaderFooterView {
    
    var titleLabel: UILabel
    
    override init(reuseIdentifier: String?) {
        titleLabel = UILabel(frame: .zero)
        super.init(reuseIdentifier: reuseIdentifier)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = R.color.textSecondary()
        let lineview = UIView(frame: .zero)
        lineview.backgroundColor = R.color.block()
        let backgroundView = UIView(frame: self.frame)
        backgroundView.backgroundColor = R.color.background()
        self.backgroundView = backgroundView
        self.addSubview(titleLabel)
        self.addSubview(lineview)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        lineview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            lineview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            lineview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            lineview.heightAnchor.constraint(equalToConstant: 1),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: lineview.topAnchor, constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchSectionHeaderView: ModelTransfer {

    func update(with model: SearchSectionHeaderViewModel) {
        titleLabel.text = model.title
    }
}
