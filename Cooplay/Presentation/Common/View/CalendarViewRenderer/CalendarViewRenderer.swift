//
//  CalendarViewRenderer.swift
//  Cooplay
//
//  Created by Alexandr on 21/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import KDCalendar
import SwiftDate

class CalendarViewRenderer: UIView {
    
    private enum Constant {
        
        enum Block {
            
            static let cornerRadius: CGFloat = 12
            static let sidesIndent: CGFloat = 24
            static let transformScale: CGFloat = 0.5
        }
        
        enum Calendar {
            
            static let sidesIndent: CGFloat = 4
            static let topIndent: CGFloat = 0
            static let height: CGFloat = 350
            static let weekdaysTopMargin: CGFloat = 16
            static let cellCornerRadius: CGFloat = 8
            static let cellFont: CGFloat = 20
            static let headerFont: CGFloat = 20
            static let weekdaysFont: CGFloat = 15
        }
        
        enum ConfirmButton {
            
            static let height: CGFloat = 56
            static let indent: CGFloat = 10
            static let fontSize: CGFloat = 20
            static let cornerRadius: CGFloat = 8
        }
        
        enum CancelButton {
            
            static let fontSize: CGFloat = 20
            static let indent: CGFloat = 10
        }
        
        enum Animation {
            static let damping: CGFloat = 0.8
            static let blockDuration: TimeInterval = 0.3
            static let backgroundDuration: TimeInterval = 0.2
        }
    }
    
    private let backgroundView: UIView
    private let blockView: UIView
    private let calendarView: UICalendarView
    private let confirmButton: UIButton
    private var selectedDate: Date!
    private var handler: ((_ date: Date) -> Void)?
    private var generator = UIImpactFeedbackGenerator(style: .medium)
    
    private var topWindow: UIWindow? {
        for window in UIApplication.shared.windows.reversed() {
            if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
        }
        return nil
    }
    
    init() {
        backgroundView = UIView(frame: .zero)
        blockView = UIView(frame: .zero)
        calendarView = UICalendarView()
        let calendarViewDateRange = DateInterval(start: Date(), end: Date() + 3.months)
        calendarView.availableDateRange = calendarViewDateRange
        calendarView.tintColor = R.color.actionAccent()
        confirmButton = UIButton(type: .system)
        super.init(frame: .zero)
        guard let window = topWindow else { return }
        self.frame = window.frame
        backgroundView.frame = window.frame
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.alpha = 0
        self.addSubview(backgroundView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        blockView.layer.cornerRadius = Constant.Block.cornerRadius
        blockView.backgroundColor = R.color.block()
        blockView.alpha = 0
        self.addSubview(blockView)
        blockView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constant.Block.sidesIndent
            ),
            blockView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -Constant.Block.sidesIndent
            ),
            blockView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        ])
        
        blockView.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.clipsToBounds = true
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(
                equalTo: blockView.leadingAnchor,
                constant: Constant.Calendar.sidesIndent
            ),
            calendarView.trailingAnchor.constraint(
                equalTo: blockView.trailingAnchor,
                constant: -Constant.Calendar.sidesIndent
            ),
            calendarView.topAnchor.constraint(
                equalTo: blockView.topAnchor,
                constant: Constant.Calendar.topIndent
            ),
            calendarView.heightAnchor.constraint(equalToConstant: Constant.Calendar.height)
        ])
        
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: Constant.ConfirmButton.fontSize)
        confirmButton.setTitleColor(R.color.textPrimary(), for: .normal)
        confirmButton.backgroundColor = R.color.actionAccent()
        confirmButton.layer.cornerRadius = Constant.ConfirmButton.cornerRadius
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        
        blockView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(
                equalTo: blockView.leadingAnchor,
                constant: Constant.ConfirmButton.indent
            ),
            confirmButton.trailingAnchor.constraint(
                equalTo: blockView.trailingAnchor,
                constant: -Constant.ConfirmButton.indent
            ),
            confirmButton.topAnchor.constraint(
                equalTo: calendarView.bottomAnchor,
                constant: 0
            ),
            confirmButton.bottomAnchor.constraint(
                equalTo: blockView.bottomAnchor,
                constant: -Constant.ConfirmButton.indent
            ),
            confirmButton.heightAnchor.constraint(equalToConstant: Constant.ConfirmButton.height)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(selectedDate: Date?, handler: ((_ date: Date) -> Void)?) {
        generator.prepare()
        self.handler = handler
        guard let window = topWindow else { return }
        window.addSubview(self)
        let components = Calendar.current.dateComponents(in: .current, from: selectedDate ?? Date())
        calendarView.visibleDateComponents = components
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        dateSelection.setSelected(components, animated: true)
        self.dateSelection(dateSelection, didSelectDate: components)
        blockView.transform = CGAffineTransform(
            scaleX: Constant.Block.transformScale,
            y: Constant.Block.transformScale
        )
        UIView.animate(
            withDuration: Constant.Animation.blockDuration,
            delay: 0,
            usingSpringWithDamping: Constant.Animation.damping,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.blockView.alpha = 1
                self.blockView.transform = .identity
            }
        )
        UIView.animate(withDuration: Constant.Animation.backgroundDuration) {
            self.backgroundView.alpha = 1
        }
    }
    
    @objc func close() {
        UIView.animate(
            withDuration: Constant.Animation.blockDuration,
            delay: 0,
            usingSpringWithDamping: Constant.Animation.damping,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: {
                self.backgroundView.alpha = 0
                self.blockView.alpha = 0
                self.blockView.transform = CGAffineTransform(
                    scaleX: Constant.Block.transformScale,
                    y: Constant.Block.transformScale
                )
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
    
    @objc func confirmAction() {
        generator.impactOccurred()
        handler?(selectedDate)
        close()
    }
}

extension CalendarViewRenderer: UICalendarSelectionSingleDateDelegate {
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let date = selection.selectedDate?.date else { return }
        
        self.selectedDate = date
        let dateString = date.toString(.custom("d MMMM"))
        UIView.performWithoutAnimation {
            self.confirmButton.setTitle(Localizable.calendarChooseAction(dateString), for: .normal)
            self.confirmButton.layoutIfNeeded()
        }
    }
    
}
