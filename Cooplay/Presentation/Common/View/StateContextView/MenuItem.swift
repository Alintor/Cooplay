//
//  MenuItem.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 29/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

struct MenuItemContainer {
    
    let item: MenuItem
    let itemView: UIView
    let scrollableContainer: MenuScrollableContainer?
}

struct MenuScrollableContainer {
    
    let scrollableView: UIView
    let scrollableConstraint: NSLayoutConstraint
}

enum MenuItemAction {
     case handleAction,
    showItems
}

protocol MenuItem {
    
    var title: String { get }
    var icon: UIImage? { get }
    var titleColor: UIColor? { get }
    var iconColor: UIColor? { get }
    
    var scrollItems: [MenuItem]? { get }
    var selectAction: MenuItemAction { get }
    var needBottomLine: Bool { get }
    var value: Any { get }
    
    func handleAction()
    func isEqual(_ item: MenuItem?) -> Bool
}

extension MenuItem {
    
    func isEqual(_ item: MenuItem?) -> Bool {
        self.title == item?.title
    }
}

struct StatusMenuItem: MenuItem {
        
    enum StatusesType {
        
        case agreement
        case confirmation
        
        var items: [User.Status] {
            switch self {
            case .agreement:
                return User.Status.agreementStatuses
            case .confirmation:
                return User.Status.confirmationStatuses
            }
        }
    }
    
    let status: User.Status
    let actionHandler: ((_ status: User.Status) -> Void)?
    
    init(status: User.Status, actionHandler: ((_ status: User.Status) -> Void)?) {
        self.status = status
        self.actionHandler = actionHandler
    }
    
    var title: String {
        return status.title()
    }
    
    var icon: UIImage? {
        return status.icon()
    }
    
    var titleColor: UIColor? {
        switch status {
        case .declined:
            return R.color.red()
        default:
            return R.color.textPrimary()
        }
    }
    
    var iconColor: UIColor? {
        switch status {
        case .declined:
            return R.color.red()
        default:
            return R.color.textPrimary()
        }
    }
    
    var needBottomLine: Bool {
        switch status {
        case .declined:
            return false
        default:
            return true
        }
    }
    
    var scrollItems: [MenuItem]? {
        switch status {
        case .late:
            return [15, 30, 45, 60].map { StatusLatenessMenuItem(lateness: $0, actionHandler: actionHandler) }
        default:
            return nil
        }
    }
    
    var selectAction: MenuItemAction {
        switch status {
        case .late:
            return .showItems
        default:
            return .handleAction
        }
    }
    
    var value: Any {
        return status
    }
    
    func handleAction() {
        actionHandler?(status)
    }
}

struct StatusLatenessMenuItem: MenuItem {
    
    let lateness: Int
    let actionHandler: ((_ status: User.Status) -> Void)?
    
    init(lateness: Int, actionHandler: ((_ status: User.Status) -> Void)?) {
        self.lateness = lateness
        self.actionHandler = actionHandler
    }
    
    var title: String {
        return "\(lateness)"
    }
    
    var icon: UIImage? {
        return nil
    }
    
    var titleColor: UIColor? {
        return R.color.textPrimary()
    }
    
    var iconColor: UIColor? {
        return nil
    }
    
    var scrollItems: [MenuItem]? {
        return nil
    }
    
    var selectAction: MenuItemAction {
        return .handleAction
    }
    
    var needBottomLine: Bool {
        return false
    }
    
    var value: Any {
        return User.Status.late(minutes: lateness)
    }
    
    func handleAction() {
        actionHandler?(User.Status.late(minutes: lateness))
    }
}

