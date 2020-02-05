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
    
}

extension SearchGameCell: ModelTransfer {

    func update(with model: SearchGameCellViewModel) {
        titleLabel.text = model.title
        if let coverPath = model.coverPath {
            coverImageView.setImage(withPath: coverPath, placeholder: R.image.commonGameCover())
        } else {
            coverImageView.image = R.image.commonGameCover()
        }
        
    }
}
