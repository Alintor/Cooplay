//
//  TimeCarouselConfiguration.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftDate

struct TimeCarouselConfiguration {
    
    enum TimeType {
        case latness
        case suggestion
    }
    
    enum SizeType: Int {
        
        case big = 0
        case short1 = 1
        case short2 = 2
        case short3 = 3
        case short4 = 4
        case short5 = 5
        
        var next: SizeType {
            switch self {
            case .big: return .short1
            case .short1: return .short2
            case .short2: return .short3
            case .short3: return .short4
            case .short4: return .short5
            case .short5: return .big
            }
        }
        
        var prev: SizeType {
            switch self {
            case .big: return .short5
            case .short1: return .big
            case .short2: return .short1
            case .short3: return .short2
            case .short4: return .short3
            case .short5: return .short4
            }
        }
        
        var isBig: Bool {
            return self == .big
        }
        
        init(minutes: Int) {
            switch minutes {
            case 0, 30, 60:
                self = .big
            case 5, 35:
                self = .short1
            case 10, 40:
                self = .short2
            case 15, 45:
                self = .short3
            case 20, 50:
                self = .short4
            case 25, 55:
                self = .short5
            default:
                self = .big
            }
        }
    }
    
    private var type: TimeType
    private var date: Date
    
    init(type: TimeType, date: Date) {
        self.type = type
        self.date = date
    }
    
    var items: [TimeCarouselItemModel] {
        var allItems = [TimeCarouselItemModel]()
        let currentValue = 0
        let currentType = SizeType(minutes: date.minute)
        let nextItems = configureNextItems(startValue: currentValue, startType: currentType, isDisable: false)
        let nextDisableItems = configureNextItems(
            startValue: nextItems.last?.value ?? currentValue,
            startType: nextItems.last?.sizeType ?? currentType,
            isDisable: true
        )
        let prevItems = configurePrevItems(startValue: currentValue, startType: currentType, isDisable: false)
        let prevDisableItems = configurePrevItems(
            startValue: prevItems.first?.value ?? currentValue,
            startType: prevItems.first?.sizeType ?? currentType,
            isDisable: true
        )
        let currentItem = TimeCarouselItemModel(
            value: currentValue,
            sizeType: currentType,
            isDisable: isCurrentDateDisable,
            nextDisable: nextItems.last == nil || isCurrentDateDisable,
            prevDisable: prevItems.first == nil || isCurrentDateDisable,
            startDate: date
        )
        
        allItems.append(contentsOf: prevDisableItems)
        allItems.append(contentsOf: prevItems)
        allItems.append(currentItem)
        allItems.append(contentsOf: nextItems)
        allItems.append(contentsOf: nextDisableItems)
        
        return allItems
    }
    
    func titleForItem(_ item: TimeCarouselItemModel) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        return timeFormatter.string(from: item.date)
    }
    
    func subtitleForItem(_ item: TimeCarouselItemModel) -> String? {
        switch type {
        case .suggestion:
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.doesRelativeDateFormatting = true
            return dateFormatter.string(from: item.date).lowercased()
        case .latness:
            return R.string.localizable.eventDetailsCellLateness("\(item.value)")
        }
    }
    
    var panelTitle: String {
        switch type {
        case .latness:
            return R.string.localizable.timeCarouselPanelLatnessTitle()
        case .suggestion:
            return R.string.localizable.timeCarouselPanelSuggestionTitle()
        }
    }
    
    private var isCurrentDateDisable: Bool {
        switch type {
        case .latness:
            return true
        case .suggestion:
            return false
        }
    }
    
    private var nextValuesLimit: Int {
        switch type {
        case .latness:
            return 12
        case .suggestion:
            return 144
        }
    }
    
    private var prevValuesLimit: Int {
        switch type {
        case .latness:
            return 0
        case .suggestion:
            return 36
        }
    }
    
    private var disableValuesLimit: Int {
        return 36
    }
    
    private var step: Int {
        return 5
    }
    
    private func configureNextItems(startValue: Int, startType: SizeType, isDisable: Bool) -> [TimeCarouselItemModel] {
        var nextItems = [TimeCarouselItemModel]()
        var value = startValue
        var sizeType = startType
        let limit = isDisable ? disableValuesLimit : nextValuesLimit
        for index in 0..<limit {
            value += step
            sizeType = sizeType.next
            nextItems.append(TimeCarouselItemModel(
                value: value,
                sizeType: sizeType,
                isDisable: isDisable,
                nextDisable: isDisable ? true : index == limit - 1,
                prevDisable: isDisable ? true : (isCurrentDateDisable && index == 0),
                startDate: date
            ))
        }
        return nextItems
    }
    
    private func configurePrevItems(startValue: Int, startType: SizeType, isDisable: Bool) -> [TimeCarouselItemModel] {
        var prevItems = [TimeCarouselItemModel]()
        var value = startValue
        var sizeType = startType
        let limit = isDisable ? disableValuesLimit : prevValuesLimit
        for index in 0..<limit {
            value -= step
            if !isDisable && (date + value.minutes) <= Date() {
                break
            }
            let nextValueOutDate = (date + (value - step).minutes) <= Date()
            sizeType = sizeType.prev
            prevItems.append(TimeCarouselItemModel(
                value: value,
                sizeType: sizeType,
                isDisable: isDisable,
                nextDisable: isDisable ? true : (isCurrentDateDisable && index == 0),
                prevDisable: isDisable ? true : (nextValueOutDate || index == limit - 1),
                startDate: date
            ))
        }
        prevItems.reverse()
        return prevItems
    }
}
