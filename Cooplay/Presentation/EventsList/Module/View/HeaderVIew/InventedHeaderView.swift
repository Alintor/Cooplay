//
//  InventedHeaderView.swift
//  Cooplay
//
//  Created by Alexandr on 06/11/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import iCarousel

final class InventedHeaderView: UIView {
    
    private enum Constant {
        
        static let size = CGSize(width: 375, height: 182)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var carousel: iCarousel!
    
    private var view: UIView!
    
    // MARK: - Init
    
    init(dataSource: iCarouselDataSource) {
        super.init(frame: CGRect(origin: .zero, size: Constant.size))
        loadNIB()
        carousel.dataSource = dataSource
        carousel.delegate = self
        carousel.isPagingEnabled = true
        carousel.bounces = false
        configureOffset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interface
    
    func animateTitle() {
        titleLabel.transform = CGAffineTransform(translationX: -frame.size.width, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.titleLabel.transform = .identity
        })
    }
    
    func removeItem(index: Int) {
        carousel.removeItem(at: index, animated: true)
    }
    
    // MARK: - Private
    
    private func loadNIB() {
        view = R.nib.inventedHeaderView(owner: self)
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        addSubview(view)
    }
    
    private func configureOffset() {
        guard carousel.numberOfItems > 1 else { return }
        if carousel.currentItemIndex == 0 {
            carousel.contentOffset = CGSize(width: -5, height: 0)
        } else if carousel.currentItemIndex == carousel.numberOfItems - 1 {
            carousel.contentOffset = CGSize(width: 5, height: 0)
        } else {
            carousel.contentOffset = .zero
        }
    }
}

extension InventedHeaderView: iCarouselDelegate {
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        configureOffset()
    }
    
}
