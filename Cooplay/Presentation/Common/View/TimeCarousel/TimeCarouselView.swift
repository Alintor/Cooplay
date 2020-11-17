//
//  TimeCarouselView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import iCarousel
import SwiftDate

class TimeCarouselView: UIView {
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    var carousel: iCarousel
    var titleLabel: UILabel
    var pointLineConstraint: NSLayoutConstraint!
    var leftGradientView: UIView!
    var rightGradientView: UIView!
    var leftGradient: CAGradientLayer!
    var rightGradient: CAGradientLayer!
    
    var models: [TimeCarouselItemModel]
    var handler: ((TimeCarouselItemModel) -> Void)?
    
    init(with configuration: TimeCarouselConfiguration, handler: ((TimeCarouselItemModel) -> Void)?) {
        models = configuration.items
        self.handler = handler
        carousel = iCarousel(frame: .zero)
        titleLabel = UILabel()
        super.init(frame: .zero)
        self.backgroundColor = R.color.block()
        titleLabel.font = UIFont.systemFont(ofSize: 22)
        titleLabel.textColor = R.color.textPrimary()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        carousel.translatesAutoresizingMaskIntoConstraints = false
        let pointLine = UIView(frame: .zero)
        pointLine.backgroundColor = R.color.actionAccent()
        pointLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addSubview(carousel)
        self.addSubview(pointLine)
        pointLineConstraint = pointLine.bottomAnchor.constraint(equalTo: carousel.bottomAnchor, constant: -16)
        
        leftGradientView = UIView(frame: .zero)
        rightGradientView = UIView(frame: .zero)
        leftGradientView.backgroundColor = .clear
        rightGradientView.backgroundColor = .clear
        leftGradient = CAGradientLayer(layer: leftGradientView.layer)
        leftGradient.colors = [R.color.block()!.cgColor, R.color.block()!.withAlphaComponent(0).cgColor]
        leftGradient.startPoint = CGPoint(x:0.3, y:0.5)
        leftGradient.endPoint = CGPoint(x:1, y:0.5)
        leftGradient.frame = leftGradientView.bounds
        leftGradientView.layer.insertSublayer(leftGradient, at: 0)
        rightGradient = CAGradientLayer(layer: rightGradientView.layer)
        rightGradient.colors = [R.color.block()!.withAlphaComponent(0).cgColor, R.color.block()!.cgColor]
        rightGradient.startPoint = CGPoint(x:0, y:0.5)
        rightGradient.endPoint = CGPoint(x:0.7, y:0.5)
        rightGradient.frame = leftGradientView.bounds
        rightGradientView.layer.insertSublayer(rightGradient, at: 0)
        leftGradientView.translatesAutoresizingMaskIntoConstraints = false
        rightGradientView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leftGradientView)
        self.addSubview(rightGradientView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            carousel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            carousel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            carousel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17),
            carousel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            carousel.heightAnchor.constraint(equalToConstant: 48),
            pointLine.topAnchor.constraint(equalTo: carousel.topAnchor, constant: -16),
            pointLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pointLine.widthAnchor.constraint(equalToConstant: 1),
            pointLineConstraint,
            leftGradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftGradientView.topAnchor.constraint(equalTo: carousel.topAnchor),
            leftGradientView.bottomAnchor.constraint(equalTo: carousel.bottomAnchor),
            leftGradientView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 5),
            rightGradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightGradientView.topAnchor.constraint(equalTo: carousel.topAnchor),
            rightGradientView.bottomAnchor.constraint(equalTo: carousel.bottomAnchor),
            rightGradientView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 5),
        ])
        titleLabel.text = "Hello"
        carousel.backgroundColor = .clear
        carousel.dataSource = self
        carousel.delegate = self
        carousel.reloadData()
        carousel.type = .cylinder
        let index = models.firstIndex { $0.value == 0 } ?? 0
        carousel.scrollToItem(at: index, animated: false)
        generator.prepare()
        //leftGradientView.isHidden = true
        //rightGradientView.isHidden = true
        //carousel.type = .cylinder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        leftGradient.frame = leftGradientView.bounds
        rightGradient.frame = rightGradientView.bounds
    }
}

extension TimeCarouselView: iCarouselDataSource {
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return models.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = (view as? TimeCarouselItemView) ?? TimeCarouselItemView(frame: CGRect(x: 0, y: 0, width: 24, height: 48))
        let model = models[index]
        cell.configure(with: model)
        return cell
    }
    
    
}

extension TimeCarouselView: iCarouselDelegate {
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        generator.impactOccurred()
        let model = models[carousel.currentItemIndex]
        if model.isDisable {
            guard
                let startIndex = models.firstIndex(where: { $0.isDisable == false }),
                let endIndex = models.lastIndex(where: { $0.isDisable == false })
            else { return }
            if carousel.currentItemIndex < startIndex {
                carousel.scrollToItem(at: startIndex, duration: 0.1)
            }
            if carousel.currentItemIndex > endIndex {
                carousel.scrollToItem(at: endIndex, duration: 0.1)
            }
        } else {
            handler?(model)
            let newDate = model.startDate + model.value.minutes
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .short
            timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
            titleLabel.text = timeFormatter.string(from: newDate)
            pointLineConstraint.constant = model.isBig ? -8 : -16
            UIView.animate(withDuration: 0.1, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .wrap {
            return 0
        } else if option == .arc {
            return CGFloat(Double.pi / 1.5)
        } else {
            return value
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        let model = models[carousel.currentItemIndex]
        if model.isDisable {
            guard
                let startIndex = models.firstIndex(where: { $0.isDisable == false }),
                let endIndex = models.lastIndex(where: { $0.isDisable == false })
            else { return }
            if carousel.currentItemIndex < startIndex {
                carousel.scrollToItem(at: startIndex, duration: 0.1)
            }
            if carousel.currentItemIndex > endIndex {
                carousel.scrollToItem(at: endIndex, duration: 0.1)
            }
        }
    }
    
//    func carouselDidEndDragging(_ carousel: iCarousel, willDecelerate decelerate: Bool) {
//        let model = models[carousel.currentItemIndex]
//        if model.isFake {
//            guard
//                let startIndex = models.firstIndex(where: { $0.isFake == false }),
//                let endIndex = models.lastIndex(where: { $0.isFake == false })
//            else { return }
//            if carousel.currentItemIndex < startIndex {
//                carousel.scrollToItem(at: startIndex, duration: 0.1)
//            }
//            if carousel.currentItemIndex > endIndex {
//                carousel.scrollToItem(at: endIndex, duration: 0.1)
//            }
//        }
//    }
}
