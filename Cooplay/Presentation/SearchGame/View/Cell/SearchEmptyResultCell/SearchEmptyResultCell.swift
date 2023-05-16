//
//  SearchEmptyResultCell.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class SearchEmptyResultCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
}

extension SearchEmptyResultCell: ModelTransfer {

    func update(with model: SearchEmptyResultCellViewModel) {
        titleLabel.text = model.title
    }
}
