//
//  ArrowsActivityIndicatorView.swift
//  Cooplay
//
//  Created by Alexandr on 25/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

final class ArrowsActivityIndicatorView: UIView {
    
    private enum Constant {
        
        static let size = CGSize(width: 200, height: 200)
        static let arrowSize = CGSize(width: 30, height: 30)
        static let originalIndent: CGFloat = 4
        static let moveingIndent: CGFloat = 12
    }
    
    let blockView: UIView
    let leftArrowConstraint: NSLayoutConstraint
    let rightArrowConstraint: NSLayoutConstraint
    let topArrowConstraint: NSLayoutConstraint
    let bottomArrowConstraint: NSLayoutConstraint
    
    private var timer: Timer?
    
    init() {
        blockView = UIView(frame: .zero)
        blockView.backgroundColor = .clear
        let leftArrowImageView = UIImageView(frame: .zero)
        leftArrowImageView.image = R.image.commonArrow()
        leftArrowImageView.contentMode = .scaleAspectFit
        let rightArrowImageView = UIImageView(frame: .zero)
        rightArrowImageView.image = R.image.commonArrow()
        rightArrowImageView.contentMode = .scaleAspectFit
        rightArrowImageView.transform = CGAffineTransform(rotationAngle: .pi)
        let topArrowImageView = UIImageView(frame: .zero)
        topArrowImageView.image = R.image.commonArrow()
        topArrowImageView.contentMode = .scaleAspectFit
        topArrowImageView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        let bottomArrowImageView = UIImageView(frame: .zero)
        bottomArrowImageView.image = R.image.commonArrow()
        bottomArrowImageView.contentMode = .scaleAspectFit
        bottomArrowImageView.transform = CGAffineTransform(rotationAngle: .pi / -2)
        leftArrowConstraint = leftArrowImageView.trailingAnchor.constraint(equalTo: blockView.centerXAnchor, constant: -Constant.originalIndent)
        rightArrowConstraint = rightArrowImageView.leadingAnchor.constraint(equalTo: blockView.centerXAnchor, constant: Constant.originalIndent)
        topArrowConstraint = topArrowImageView.bottomAnchor.constraint(equalTo: blockView.centerYAnchor, constant: -Constant.originalIndent)
        bottomArrowConstraint = bottomArrowImageView.topAnchor.constraint(equalTo: blockView.centerYAnchor, constant: Constant.originalIndent)
        super.init(frame: CGRect(origin: .zero, size: Constant.size))
        self.backgroundColor = .clear
        self.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockView.widthAnchor.constraint(equalToConstant: Constant.size.width),
            blockView.heightAnchor.constraint(equalToConstant: Constant.size.height),
            blockView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blockView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        blockView.addSubview(leftArrowImageView)
        blockView.addSubview(rightArrowImageView)
        blockView.addSubview(topArrowImageView)
        blockView.addSubview(bottomArrowImageView)
        leftArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        topArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftArrowImageView.centerYAnchor.constraint(equalTo: blockView.centerYAnchor),
            rightArrowImageView.centerYAnchor.constraint(equalTo: blockView.centerYAnchor),
            topArrowImageView.centerXAnchor.constraint(equalTo: blockView.centerXAnchor),
            bottomArrowImageView.centerXAnchor.constraint(equalTo: blockView.centerXAnchor),
            leftArrowImageView.widthAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            leftArrowImageView.heightAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            rightArrowImageView.widthAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            rightArrowImageView.heightAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            topArrowImageView.widthAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            topArrowImageView.heightAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            bottomArrowImageView.widthAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            bottomArrowImageView.heightAnchor.constraint(equalToConstant: Constant.arrowSize.width),
            leftArrowConstraint,
            rightArrowConstraint,
            topArrowConstraint,
            bottomArrowConstraint
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArrowsActivityIndicatorView: ActivityIndicatorView {
    
    func start() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(
            withTimeInterval: 2,
            repeats: true
        ) { [weak self] _ in
            self?.animate()
        }
        timer?.fire()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        blockView.layer.removeAllAnimations()
    }
    
    @objc func animate() {
        leftArrowConstraint.constant = -Constant.moveingIndent
        rightArrowConstraint.constant = Constant.moveingIndent
        topArrowConstraint.constant = -Constant.moveingIndent
        bottomArrowConstraint.constant = Constant.moveingIndent
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.blockView.transform = CGAffineTransform(rotationAngle: .pi)
            self.layoutIfNeeded()
            
        }) { (_) in
            self.leftArrowConstraint.constant = -Constant.originalIndent
            self.rightArrowConstraint.constant = Constant.originalIndent
            self.topArrowConstraint.constant = -Constant.originalIndent
            self.bottomArrowConstraint.constant = Constant.originalIndent
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.blockView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                self.layoutIfNeeded()
            })
        }
    }
}
