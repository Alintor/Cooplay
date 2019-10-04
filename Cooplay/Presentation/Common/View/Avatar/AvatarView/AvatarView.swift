//
//  AvatarView.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

@IBDesignable final class AvatarView: UIView {
    
    @IBOutlet weak var firstNameLetterLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var view: UIView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNIB()
    }
    
    // MARK: - Interface
    
    func update(with model: AvatarViewModel) {
        firstNameLetterLabel.text = model.firstNameLetter
        view.backgroundColor = model.backgroundColor
        // TODO: load image
    }
    
    // MARK: - Private
    
    private func loadNIB() {
        view = R.nib.avatarView.firstView(owner: self)
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
}
