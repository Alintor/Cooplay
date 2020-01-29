//
//  NewEventGameCell.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

class NewEventGameCell: UICollectionViewCell {
    
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverMaskView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusIconImageView: UIImageView!
    
    var isGameSelected: Bool = false
    var selectAction: ((_ isSelected: Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        //tap.minimumPressDuration = 0
        //tap.delegate = self
        blockView.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        isGameSelected = !isGameSelected
        selectAction?(isGameSelected)
    }
    
    private func configureStatus() {
        if isGameSelected {
            blockView.backgroundColor = R.color.actionAccent()
            coverMaskView.isHidden = true
            statusView.backgroundColor = R.color.actionAccent()
            statusView.layer.borderColor = R.color.actionAccent()?.cgColor
            statusIconImageView.isHidden = false
        } else {
            blockView.backgroundColor = .clear
            coverMaskView.isHidden = false
            statusView.backgroundColor = R.color.background()
            statusView.layer.borderColor = R.color.textSecondary()?.cgColor
            statusView.layer.borderWidth = 1
            statusIconImageView.isHidden = true
        }
    }
}

extension NewEventGameCell: ConfigurableCell {
    typealias T = NewEventGameCellViewModel
    
    func configure(model: NewEventGameCellViewModel) {
        self.isGameSelected = model.isSelected
        self.selectAction = model.selectAction
        coverImageView.setImage(withPath: model.coverPath, placeholder: R.image.commonGameCover())
        configureStatus()
    }
}
