//
//  AvatarView.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

@IBDesignable final class AvatarView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
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
        backgroundView.backgroundColor = model.backgroundColor
        if let imagePath = model.avatarPath {
            iconImageView.setImage(withPath: imagePath)
        }
        configureView()
    }
    
    func update(with count: Int) {
        firstNameLetterLabel.text = "+\(count)"
        backgroundView.backgroundColor = R.color.shapeBackground()
        configureView()
    }
    
    // MARK: - Private
    
    private func configureView() {
        let diameter = view.frame.size.width
        firstNameLetterLabel.font = firstNameLetterLabel.font.withSize(diameter / 2)
        backgroundView.layer.cornerRadius = diameter / 2
    }
    
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
