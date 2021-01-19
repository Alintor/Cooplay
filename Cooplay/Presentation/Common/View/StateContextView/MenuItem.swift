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
    showItems,
    showPanel
}

protocol MenuPanelItem: class {
    
    var panelView: UIView { get }
    var cancelHandler: (() -> Void)? { get set }
    var confirmHandler: (() -> Void)? { get set }
    func loadData()
}

protocol MenuItem {
    
    var title: String { get }
    var icon: UIImage? { get }
    var titleColor: UIColor? { get }
    var iconColor: UIColor? { get }
    
    var scrollItems: [MenuItem]? { get }
    var menuPanelItem: MenuPanelItem? { get }
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
    let timeCarouselPanel: TimeCarouselPanel?
    let actionHandler: ((_ status: User.Status) -> Void)?
    
    init(status: User.Status, date: Date, actionHandler: ((_ status: User.Status) -> Void)?) {
        self.status = status
        self.actionHandler = actionHandler
        switch status {
        case .late:
            timeCarouselPanel = TimeCarouselPanel(configuration: .init(type: .latness, date: date))
        default:
            timeCarouselPanel = nil
        }
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
    
    var menuPanelItem: MenuPanelItem? {
        return timeCarouselPanel
    }
    
    var scrollItems: [MenuItem]? {
        return nil
//        switch status {
//        case .late:
//            return [15, 30, 45, 60].map { StatusLatenessMenuItem(lateness: $0, actionHandler: actionHandler) }
//        default:
//            return nil
//        }
    }
    
    var selectAction: MenuItemAction {
        switch status {
        case .late:
            return .showPanel
        default:
            return .handleAction
        }
    }
    
    var value: Any {
        switch status {
        case .late:
            return timeCarouselPanel?.status ?? status
        default:
            return status
        }
    }
    
    func handleAction() {
        switch status {
        case .late:
            actionHandler?(timeCarouselPanel?.status ?? status)
        default:
            actionHandler?(status)
        }
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
    
    var menuPanelItem: MenuPanelItem? {
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

struct EventMemberMenuItem: MenuItem {
    
    enum ActionType: CaseIterable {
        case makeOwner
        case delete
    }
    
    enum MenuGroup {
        
        case editing
        
        var items: [ActionType] {
            switch self {
            case .editing:
                return [.makeOwner, .delete]
            }
        }
    }
    
    let actionType: ActionType
    let actionHandler: ((_ actionType: ActionType) -> Void)?
    
    init(actionType: ActionType, actionHandler: ((_ actionType: ActionType) -> Void)?) {
        self.actionType = actionType
        self.actionHandler = actionHandler
    }
    
    var title: String {
        switch actionType {
        case .makeOwner:
            return R.string.localizable.eventMemberMenuItemMakeOwner()
        case .delete:
            return R.string.localizable.eventMemberMenuItemDelete()
        }
    }
    
    var icon: UIImage? {
        switch actionType {
        case .makeOwner:
            return R.image.commonSmallCrown()
        case .delete:
            return R.image.statusNormalDeclined()
        }
    }
    
    var titleColor: UIColor? {
        switch actionType {
        case .makeOwner:
            return R.color.textPrimary()
        case .delete:
            return R.color.red()
        }
    }
    
    var iconColor: UIColor? {
        switch actionType {
        case .makeOwner:
            return R.color.yellow()
        case .delete:
            return R.color.red()
        }
    }
    
    var menuPanelItem: MenuPanelItem? {
        return nil
    }
    
    var scrollItems: [MenuItem]? {
        return nil
    }
    
    var selectAction: MenuItemAction {
        return .handleAction
    }
    
    var needBottomLine: Bool {
        switch actionType {
        case .delete:
            return false
        default:
            return true
        }
    }
    
    var value: Any {
        return actionType
    }
    
    func handleAction() {
        actionHandler?(actionType)
    }
    
    
}
