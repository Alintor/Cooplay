//
//  TimeCarouselPanel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

class TimeCarouselPanel: UIView {
    
    private var carouselItem: TimeCarouselItemModel!
    private var timeCarouselView: TimeCarouselView!
    private var configuration: TimeCarouselConfiguration
    
    init(configuration: TimeCarouselConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        self.backgroundColor = R.color.block()
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(R.string.localizable.commonCancel(), for: .normal)
        cancelButton.tintColor = R.color.actionAccent()
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle(R.string.localizable.commonDone(), for: .normal)
        confirmButton.tintColor = R.color.actionAccent()
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = R.color.textPrimary()
        titleLabel.text = configuration.panelTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let line = UIView(frame: .zero)
        line.backgroundColor = R.color.shapeBackground()
        line.translatesAutoresizingMaskIntoConstraints = false
        timeCarouselView = TimeCarouselView(with: configuration) { [weak self] (item) in
            self?.carouselItem = item
        }
        timeCarouselView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        self.addSubview(cancelButton)
        self.addSubview(confirmButton)
        self.addSubview(line)
        self.addSubview(timeCarouselView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            confirmButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            line.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 1),
            timeCarouselView.topAnchor.constraint(equalTo: line.bottomAnchor),
            timeCarouselView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            timeCarouselView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            timeCarouselView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var status: User.Status {
        switch configuration.type {
        case .latness:
            return .late(minutes: carouselItem.value)
        case .suggestion:
            return .suggestDate(minutes: carouselItem.value)
        default:
            return .accepted
        }
    }
    
    var date: Date {
        return carouselItem.date
    }
    
    var cancelHandler: (() -> Void)?
    var confirmHandler: (() -> Void)?
    var statusHandler: ((_ status: User.Status) -> Void)?
    
    @objc func cancelButtonTapped() {
        cancelHandler?()
    }
    
    @objc func confirmButtonTapped() {
        confirmHandler?()
        statusHandler?(status)
    }
}

extension TimeCarouselPanel: MenuPanelItem {
    
    var panelView: UIView {
        return self
    }
    
    func loadData() {
        timeCarouselView.reloadData()
    }
}
