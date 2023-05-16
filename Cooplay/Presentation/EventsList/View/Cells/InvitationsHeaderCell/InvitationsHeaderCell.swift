//
//  InvitationsHeaderCell.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 11/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import iCarousel
import DTModelStorage

class InvitationsHeaderCell: UITableViewCell {
    
    static let defaultHeight: CGFloat = 126

    @IBOutlet weak var carousel: iCarousel!
    private var selectionAction: ((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureOffset()
    }
    
    private func configureOffset() {
        guard carousel.numberOfItems > 1 else {
            carousel.contentOffset = .zero
            return
        }
        if carousel.currentItemIndex == 0 {
            carousel.contentOffset = CGSize(width: -5, height: 0)
        } else if carousel.currentItemIndex == carousel.numberOfItems - 1 {
            carousel.contentOffset = CGSize(width: 5, height: 0)
        } else {
            carousel.contentOffset = .zero
        }
    }
    
}

extension InvitationsHeaderCell: ModelTransfer {

    func update(with model: InvitationsHeaderCellViewModel) {
        self.selectionAction = model.selectionAction
        carousel.dataSource = model.dataSource
        carousel.delegate = self
        carousel.isPagingEnabled = true
        carousel.bounces = false
        carousel.reloadData()
        configureOffset()
    }
}

extension InvitationsHeaderCell: iCarouselDelegate {
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        configureOffset()
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        selectionAction?(index)
    }
}
