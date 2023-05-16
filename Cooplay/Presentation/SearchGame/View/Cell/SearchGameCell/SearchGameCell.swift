//
//  SearchGameCell.swift
//  Cooplay
//
//  Created by Alexandr on 04/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import DTModelStorage

class SearchGameCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    
}

extension SearchGameCell: ModelTransfer {

    func update(with model: SearchGameCellViewModel) {
        titleLabel.text = model.title
        if let coverPath = model.coverPath {
            coverImageView.setImage(withPath: coverPath, placeholder: R.image.commonGameCover())
        } else {
            coverImageView.image = R.image.commonGameCover()
        }
        selectionView.isHidden = !model.isSelected
        self.isUserInteractionEnabled = !model.isSelected
        coverImageView.alpha = model.isSelected ? 0.2 : 1
        titleLabel.alpha = model.isSelected ? 0.2 : 1
        selectionView.alpha = model.isSelected ? 0.2 : 1
    }
}
