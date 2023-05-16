//
//  NewEventGameCell.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

class NewEventGameCell: UICollectionViewCell, Skeletonable {
    
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusIconImageView: UIImageView!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    var isGameSelected: Bool = false
    var selectAction: ((_ isSelected: Bool) -> Void)?
    var generator: UIImpactFeedbackGenerator?
    
    var skeletonViews: [UIView]?
    
    var targetViews: [(view: UIView, cornerRadius: CGFloat)] {
        return [(blockView, blockView.layer.cornerRadius)]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        blockView.addGestureRecognizer(tap)
        statusView.alpha = 0
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        guard !isGameSelected else { return }
        isGameSelected = !isGameSelected
        generator?.impactOccurred()
        self.selectAction?(self.isGameSelected)
        self.generator?.prepare()
//        setupState(animate: true) {
//            self.selectAction?(self.isGameSelected)
//            self.generator?.prepare()
//        }
    }
    
    private func setupState(animate: Bool, completion: (() -> Void)?) {
        if isGameSelected {
            imageViewLeadingConstraint.constant = 4
            imageViewTrailingConstraint.constant = 4
            imageViewTopConstraint.constant = 4
            imageViewBottomConstraint.constant = 4
        } else {
            imageViewLeadingConstraint.constant = 0
            imageViewTrailingConstraint.constant = 0
            imageViewTopConstraint.constant = 0
            imageViewBottomConstraint.constant = 0
        }
        guard animate else {
            configureStatus()
            completion?()
            return
        }
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, animations: {
            self.configureStatus()
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.isUserInteractionEnabled = true
            completion?()
        })
    }
    
    private func configureStatus() {
        if isGameSelected {
            coverImageView.alpha = 1
            statusView.alpha = 1
            blockView.layer.borderWidth = 2
            blockView.layer.borderColor = R.color.actionAccent()?.cgColor
        } else {
            coverImageView.alpha = 0.8
            statusView.alpha = 0
            blockView.layer.borderWidth = 0
        }
    }
    
    func prepereView() {
        statusView.isHidden = true
    }
    
    func restoreView() {
        statusView.isHidden = false
    }
}

extension NewEventGameCell: ConfigurableCell {
    typealias T = NewEventGameCellViewModel
    
    func configure(model: NewEventGameCellViewModel) {
        generator = UIImpactFeedbackGenerator(style: .medium)
        generator?.prepare()
        self.isUserInteractionEnabled = true
        self.hideSkeleton()
        self.selectAction = model.selectAction
        if let coverPath = model.coverPath {
            coverImageView.setImage(withPath: coverPath, placeholder: R.image.commonGameCover())
        } else {
            coverImageView.image = R.image.commonGameCover()
        }
        if let prevState = model.prevState {
            self.isGameSelected = prevState
            setupState(animate: false, completion: nil)
            self.isGameSelected = model.isSelected
            if model.isSelected != prevState {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.setupState(animate: true, completion: nil)
                }
            } else {
                setupState(animate: false, completion: nil)
            }
        } else {
            self.isGameSelected = model.isSelected
            setupState(animate: false, completion: nil)
        }
        
    }
    
    static var reuseIdentifier: String {
        return R.reuseIdentifier.newEventGameCell.identifier
    }
}
