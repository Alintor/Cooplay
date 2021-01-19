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
    
    var generator: UIImpactFeedbackGenerator?
    var carousel: iCarousel
    var titleLabel: UILabel
    var subtitleLabel: UILabel
    var pointLineConstraint: NSLayoutConstraint!
    var leftGradientView: UIView!
    var rightGradientView: UIView!
    var leftGradient: CAGradientLayer!
    var rightGradient: CAGradientLayer!
    var nexButton: UIButton
    var prevButton: UIButton
    
    var models: [TimeCarouselItemModel]
    var handler: ((TimeCarouselItemModel) -> Void)?
    var configuration: TimeCarouselConfiguration
    
    init(with configuration: TimeCarouselConfiguration, handler: ((TimeCarouselItemModel) -> Void)?) {
        // Setup
        models = configuration.items
        self.handler = handler
        self.configuration = configuration
        carousel = iCarousel(frame: .zero)
        carousel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel = UILabel()
        subtitleLabel = UILabel()
        nexButton = UIButton(type: .system)
        prevButton = UIButton(type: .system)
        super.init(frame: .zero)
        self.backgroundColor = R.color.block()
        // Titles
        titleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = R.color.textPrimary()
        titleLabel.textAlignment = .center
        titleLabel.text = " "
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = R.color.textSecondary()
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = " "
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 1
        textStackView.alignment = .center
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        // Buttons
        nexButton.setImage(R.image.commonPlus(), for: .normal)
        nexButton.tintColor = R.color.actionAccent()
        nexButton.backgroundColor = R.color.shapeBackground()
        nexButton.layer.cornerRadius = 20
        nexButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nexButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setImage(R.image.commonMinus(), for: .normal)
        prevButton.tintColor = R.color.actionAccent()
        prevButton.backgroundColor = R.color.shapeBackground()
        prevButton.layer.cornerRadius = 20
        prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Point line
        let pointLine = UIView(frame: .zero)
        pointLine.layer.cornerRadius = 0.5
        pointLine.backgroundColor = R.color.actionAccent()
        pointLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textStackView)
        self.addSubview(carousel)
        self.addSubview(nexButton)
        self.addSubview(prevButton)
        self.addSubview(pointLine)
        pointLineConstraint = pointLine.bottomAnchor.constraint(equalTo: carousel.bottomAnchor, constant: -16)
        // Gradients
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
        // Constraints
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            textStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textStackView.widthAnchor.constraint(equalToConstant: 100),
            nexButton.leadingAnchor.constraint(equalTo: textStackView.trailingAnchor, constant: 8),
            nexButton.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor),
            nexButton.heightAnchor.constraint(equalToConstant: 40),
            nexButton.widthAnchor.constraint(equalToConstant: 48),
            prevButton.trailingAnchor.constraint(equalTo: textStackView.leadingAnchor, constant: -8),
            prevButton.centerYAnchor.constraint(equalTo: textStackView.centerYAnchor),
            prevButton.heightAnchor.constraint(equalToConstant: 40),
            prevButton.widthAnchor.constraint(equalToConstant: 48),
            carousel.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 20),
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
            leftGradientView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 8),
            rightGradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rightGradientView.topAnchor.constraint(equalTo: carousel.topAnchor),
            rightGradientView.bottomAnchor.constraint(equalTo: carousel.bottomAnchor),
            rightGradientView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 8),
        ])
        // Carousel setup
        carousel.backgroundColor = .clear
        //carousel.dataSource = self
        //carousel.delegate = self
        //carousel.reloadData()
        carousel.type = .cylinder
        //let index = models.firstIndex { $0.isDisable == false } ?? 0
        //carousel.scrollToItem(at: index, animated: false)
        //generator = UIImpactFeedbackGenerator(style: .light)
        //generator?.prepare()
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
    
    func reloadData() {
        carousel.dataSource = self
        carousel.delegate = self
        carousel.reloadData()
        let index = models.firstIndex { $0.value >= 0 && $0.isDisable == false } ?? 0
        carousel.scrollToItem(at: index, animated: false)
        generator = UIImpactFeedbackGenerator(style: .light)
        generator?.prepare()
    }
    
    @objc func nextButtonTapped() {
        carousel.scrollToItem(at: carousel.currentItemIndex + 1, duration: 0.2)
    }
    
    @objc func prevButtonTapped() {
        carousel.scrollToItem(at: carousel.currentItemIndex - 1, duration: 0.2)
    }
    
    private func setupButtons() {
        let nextIndex = carousel.currentItemIndex + 1
        let prevIndex = carousel.currentItemIndex - 1
        if nextIndex < models.count {
            nexButton.isEnabled = !models[nextIndex].isDisable
        }
        if prevIndex >= 0 {
            prevButton.isEnabled = !models[prevIndex].isDisable
        }
    }
    
    private func returnToEnabledItems() {
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
        let model = models[carousel.currentItemIndex]
        if model.isDisable {
            returnToEnabledItems()
        } else {
            generator?.impactOccurred()
            handler?(model)
            setupButtons()
            titleLabel.text = configuration.titleForItem(model)
            subtitleLabel.text = configuration.subtitleForItem(model)
            subtitleLabel.isHidden = subtitleLabel.text == nil
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
            return CGFloat(Double.pi / 2)
        } else {
            return value
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        let model = models[carousel.currentItemIndex]
        if model.isDisable {
            returnToEnabledItems()
        }
    }
}
