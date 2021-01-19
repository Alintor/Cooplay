//
//  NewEventTimePickerView.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftDate

protocol NewEventTimePickerViewDelegate: class {
    
    var timeButtonView: UIView { get }
    func prepareTimeView(completion: @escaping () -> Void)
    func restoreView()
}

extension NewEventTimePickerViewDelegate {
    
    var timeButtonViewGlobalPoint: CGPoint {
        return timeButtonView.superview?.convert(timeButtonView.frame.origin, to: nil) ?? timeButtonView.frame.origin
    }
    
    var timeButtonViewSize: CGSize {
        return timeButtonView.frame.size
    }
    
    func setTimeButtonView(hide: Bool) {
        timeButtonView.isHidden = hide
    }
}

final class NewEventTimePickerView: UIView {
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var timePickerBlockView: UIView?
    private var timePicker: UIDatePicker?
    private var timeButtonView: NewEventTimeButtonView?
    private weak var delegate: NewEventTimePickerViewDelegate?
    private var timeHandler: ((_ date: Date) -> Void)?
    private var blockViewYConstraint: NSLayoutConstraint?
    private var blockTransform: CGAffineTransform?
    
    private var selectedTime: Date!
    
    var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    init(delegate: NewEventTimePickerViewDelegate?, timeHandler: ((_ date: Date) -> Void)?) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.timeHandler = timeHandler
        guard let window = topWindow else { return }
        self.frame = window.frame
        blurEffectView.frame = self.frame
        blurEffectView.alpha = 0
        self.addSubview(blurEffectView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(startTime: Date = Date(), showDate: Bool, enableMinimumTime: Bool) {
        selectedTime = startTime
        topWindow?.addSubview(self)
        delegate?.prepareTimeView { [weak self] in
            self?.showViews(startTime: startTime, showDate: showDate, enableMinimumTime: enableMinimumTime)
        }
    }
    
    private func showViews(startTime: Date, showDate: Bool, enableMinimumTime: Bool) {
        guard
            let window = topWindow,
            let delegate = delegate
        else { return }
        let width = self.frame.width - 20
        let timeButtonView = NewEventTimeButtonView(
            frame: CGRect(origin: delegate.timeButtonViewGlobalPoint, size: delegate.timeButtonViewSize)
        )
        timeButtonView.setTime(startTime)
        timeButtonView.arrowImageView.image = R.image.commonArrowUp()
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(closeConfirm))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(closeConfirm))
        blurEffectView.addGestureRecognizer(tapGestureRecognizer1)
        timeButtonView.addGestureRecognizer(tapGestureRecognizer2)
        self.timeButtonView = timeButtonView
        self.addSubview(timeButtonView)
        
        let timePickerBlockView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 215))
        timePickerBlockView.backgroundColor = R.color.block()
        timePickerBlockView.layer.cornerRadius = 12
        self.timePickerBlockView = timePickerBlockView
        self.addSubview(timePickerBlockView)
        timePickerBlockView.translatesAutoresizingMaskIntoConstraints = false
        
        let timePicker = UIDatePicker(frame: .zero)
        if showDate {
            timePicker.datePickerMode = .dateAndTime
        } else {
            timePicker.datePickerMode = .time
        }
        timePicker.minuteInterval = 5
        timePicker.setValue(R.color.textPrimary(), forKeyPath: "textColor")
        timePicker.tintColor = R.color.textPrimary()
        timePicker.setDate(startTime, animated: false)
        if enableMinimumTime {
            timePicker.minimumDate = Date() + 10.minutes
        }
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        self.timePicker = timePicker
        timePickerBlockView.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let blockViewYConstraint = timePickerBlockView.bottomAnchor.constraint(equalTo: timeButtonView.topAnchor, constant: -10)
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: timePickerBlockView.topAnchor, constant: 0),
            timePicker.bottomAnchor.constraint(equalTo: timePickerBlockView.bottomAnchor, constant: 0),
            timePicker.leadingAnchor.constraint(equalTo: timePickerBlockView.leadingAnchor, constant: 0),
            timePicker.trailingAnchor.constraint(equalTo: timePickerBlockView.trailingAnchor, constant: 0),
            timePicker.widthAnchor.constraint(equalToConstant: width),
            timePickerBlockView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            blockViewYConstraint
        ])
        let blockTransform = CGAffineTransform(scaleX: 0.85, y: 0.85).translatedBy(x: 0, y: timeButtonView.frame.height)
        timePickerBlockView.transform = blockTransform
        self.blockTransform = blockTransform
        self.blockViewYConstraint = blockViewYConstraint
        
        timePickerBlockView.alpha = 0
        delegate.setTimeButtonView(hide: true)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        timeButtonView.frame.size.width = width
        timeButtonView.center.x = window.center.x
        UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.timePickerBlockView?.transform = .identity
            self.timePickerBlockView?.alpha = 1
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            timeButtonView.frame.origin.y =
            window.frame.height - window.safeAreaInsets.bottom - timeButtonView.frame.height - 10
            
        })
        UIView.animate(withDuration: 0.25, animations: {
            self.blurEffectView.alpha = 1
        }) { (_) in
            generator.impactOccurred()
        }
    }
    
    @objc private func closeConfirm() {
        timeHandler?(selectedTime)
        close()
    }
    
    @objc private func close() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        self.blockViewYConstraint?.isActive = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.timePickerBlockView?.transform = self.blockTransform!
            self.timePickerBlockView?.alpha = 0
        })
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.blurEffectView.alpha = 0
                guard let delegate = self.delegate else { return }
                self.timeButtonView?.frame = CGRect(
                    origin: delegate.timeButtonViewGlobalPoint,
                    size: delegate.timeButtonViewSize
                )
            },
            completion: { _ in
                generator.impactOccurred()
                self.delegate?.setTimeButtonView(hide: false)
                self.delegate?.restoreView()
                self.removeFromSuperview()
            }
        )
    }
    
    @objc private func timePickerValueChanged(_ sender: UIDatePicker) {
        timeButtonView?.setTime(sender.date)
        selectedTime = sender.date
    }
}

extension NewEventTimePickerView: UIPickerViewDelegate {
    
}
