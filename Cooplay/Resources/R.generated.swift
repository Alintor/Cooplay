//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 10 colors.
  struct color {
    /// Color `action.accent`.
    static let actionAccent = Rswift.ColorResource(bundle: R.hostingBundle, name: "action.accent")
    /// Color `background`.
    static let background = Rswift.ColorResource(bundle: R.hostingBundle, name: "background")
    /// Color `block`.
    static let block = Rswift.ColorResource(bundle: R.hostingBundle, name: "block")
    /// Color `green`.
    static let green = Rswift.ColorResource(bundle: R.hostingBundle, name: "green")
    /// Color `grey`.
    static let grey = Rswift.ColorResource(bundle: R.hostingBundle, name: "grey")
    /// Color `red`.
    static let red = Rswift.ColorResource(bundle: R.hostingBundle, name: "red")
    /// Color `shape.background`.
    static let shapeBackground = Rswift.ColorResource(bundle: R.hostingBundle, name: "shape.background")
    /// Color `text.primary`.
    static let textPrimary = Rswift.ColorResource(bundle: R.hostingBundle, name: "text.primary")
    /// Color `text.secondary`.
    static let textSecondary = Rswift.ColorResource(bundle: R.hostingBundle, name: "text.secondary")
    /// Color `yellow`.
    static let yellow = Rswift.ColorResource(bundle: R.hostingBundle, name: "yellow")
    
    /// `UIColor(named: "action.accent", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func actionAccent(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.actionAccent, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "background", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func background(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.background, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "block", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func block(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.block, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "green", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func green(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.green, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "grey", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func grey(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.grey, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "red", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.red, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "shape.background", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func shapeBackground(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.shapeBackground, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "text.primary", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func textPrimary(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.textPrimary, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "text.secondary", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func textSecondary(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.textSecondary, compatibleWith: traitCollection)
    }
    
    /// `UIColor(named: "yellow", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func yellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.yellow, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 12 images.
  struct image {
    /// Image `common.arrowDown`.
    static let commonArrowDown = Rswift.ImageResource(bundle: R.hostingBundle, name: "common.arrowDown")
    /// Image `common.details`.
    static let commonDetails = Rswift.ImageResource(bundle: R.hostingBundle, name: "common.details")
    /// Image `common.gamepadArrow`.
    static let commonGamepadArrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "common.gamepadArrow")
    /// Image `status.normal.declined`.
    static let statusNormalDeclined = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.normal.declined")
    /// Image `status.normal.late`.
    static let statusNormalLate = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.normal.late")
    /// Image `status.normal.maybe`.
    static let statusNormalMaybe = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.normal.maybe")
    /// Image `status.normal.ontime`.
    static let statusNormalOntime = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.normal.ontime")
    /// Image `status.normal.unknown`.
    static let statusNormalUnknown = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.normal.unknown")
    /// Image `status.small.declined`.
    static let statusSmallDeclined = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.small.declined")
    /// Image `status.small.maybe`.
    static let statusSmallMaybe = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.small.maybe")
    /// Image `status.small.ontime`.
    static let statusSmallOntime = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.small.ontime")
    /// Image `status.small.unknown`.
    static let statusSmallUnknown = Rswift.ImageResource(bundle: R.hostingBundle, name: "status.small.unknown")
    
    /// `UIImage(named: "common.arrowDown", bundle: ..., traitCollection: ...)`
    static func commonArrowDown(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.commonArrowDown, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "common.details", bundle: ..., traitCollection: ...)`
    static func commonDetails(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.commonDetails, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "common.gamepadArrow", bundle: ..., traitCollection: ...)`
    static func commonGamepadArrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.commonGamepadArrow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.normal.declined", bundle: ..., traitCollection: ...)`
    static func statusNormalDeclined(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusNormalDeclined, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.normal.late", bundle: ..., traitCollection: ...)`
    static func statusNormalLate(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusNormalLate, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.normal.maybe", bundle: ..., traitCollection: ...)`
    static func statusNormalMaybe(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusNormalMaybe, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.normal.ontime", bundle: ..., traitCollection: ...)`
    static func statusNormalOntime(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusNormalOntime, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.normal.unknown", bundle: ..., traitCollection: ...)`
    static func statusNormalUnknown(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusNormalUnknown, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.small.declined", bundle: ..., traitCollection: ...)`
    static func statusSmallDeclined(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusSmallDeclined, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.small.maybe", bundle: ..., traitCollection: ...)`
    static func statusSmallMaybe(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusSmallMaybe, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.small.ontime", bundle: ..., traitCollection: ...)`
    static func statusSmallOntime(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusSmallOntime, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "status.small.unknown", bundle: ..., traitCollection: ...)`
    static func statusSmallUnknown(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.statusSmallUnknown, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 3 nibs.
  struct nib {
    /// Nib `ActiveEventCell`.
    static let activeEventCell = _R.nib._ActiveEventCell()
    /// Nib `AvatarView`.
    static let avatarView = _R.nib._AvatarView()
    /// Nib `EventCell`.
    static let eventCell = _R.nib._EventCell()
    
    /// `UINib(name: "ActiveEventCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.activeEventCell) instead")
    static func activeEventCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.activeEventCell)
    }
    
    /// `UINib(name: "AvatarView", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.avatarView) instead")
    static func avatarView(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.avatarView)
    }
    
    /// `UINib(name: "EventCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.eventCell) instead")
    static func eventCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.eventCell)
    }
    
    static func activeEventCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ActiveEventCell? {
      return R.nib.activeEventCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ActiveEventCell
    }
    
    static func avatarView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.avatarView.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }
    
    static func eventCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventCell? {
      return R.nib.eventCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventCell
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `ActiveEventCell`.
    static let activeEventCell: Rswift.ReuseIdentifier<ActiveEventCell> = Rswift.ReuseIdentifier(identifier: "ActiveEventCell")
    /// Reuse identifier `EventCell`.
    static let eventCell: Rswift.ReuseIdentifier<EventCell> = Rswift.ReuseIdentifier(identifier: "EventCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `EventsList`.
    static let eventsList = _R.storyboard.eventsList()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    
    /// `UIStoryboard(name: "EventsList", bundle: ...)`
    static func eventsList(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.eventsList)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 18 localization keys.
    struct localizable {
      /// Value: Localizable
      static let tableName = Rswift.StringResource(key: "tableName", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Ближайшее событие
      static let eventsListSectionsActive = Rswift.StringResource(key: "eventsList.sections.active", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Будущие события
      static let eventsListSectionsFuture = Rswift.StringResource(key: "eventsList.sections.future", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Вовремя
      static let statusOntimeShort = Rswift.StringResource(key: "status.ontime.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Возможно
      static let statusMaybeShort = Rswift.StringResource(key: "status.maybe.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Возможно, пойду
      static let statusMaybeFull = Rswift.StringResource(key: "status.maybe.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Все события
      static let eventsListTitle = Rswift.StringResource(key: "eventsList.title", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Не пойду
      static let statusDeclinedFull = Rswift.StringResource(key: "status.declined.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Не пойду
      static let statusDeclinedShort = Rswift.StringResource(key: "status.declined.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Опоздаю
      static let statusLateShort = Rswift.StringResource(key: "status.late.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Опоздаю на %d мин
      static let statusLateFull = Rswift.StringResource(key: "status.late.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Отказался
      static let eventsListSectionsDeclined = Rswift.StringResource(key: "eventsList.sections.declined", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Пойду
      static let statusAcceptedShort = Rswift.StringResource(key: "status.accepted.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Приглашен
      static let eventsListSectionsInvited = Rswift.StringResource(key: "eventsList.sections.invited", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Приглашен
      static let statusUnknownFull = Rswift.StringResource(key: "status.unknown.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Приглашен
      static let statusUnknownShort = Rswift.StringResource(key: "status.unknown.short", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Приду вовремя
      static let statusAcceptedFull = Rswift.StringResource(key: "status.accepted.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Приду вовремя
      static let statusOntimeFull = Rswift.StringResource(key: "status.ontime.full", tableName: "Localizable", bundle: R.hostingBundle, locales: [], comment: nil)
      
      /// Value: Localizable
      static func tableName(_: Void = ()) -> String {
        return NSLocalizedString("tableName", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Ближайшее событие
      static func eventsListSectionsActive(_: Void = ()) -> String {
        return NSLocalizedString("eventsList.sections.active", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Будущие события
      static func eventsListSectionsFuture(_: Void = ()) -> String {
        return NSLocalizedString("eventsList.sections.future", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Вовремя
      static func statusOntimeShort(_: Void = ()) -> String {
        return NSLocalizedString("status.ontime.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Возможно
      static func statusMaybeShort(_: Void = ()) -> String {
        return NSLocalizedString("status.maybe.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Возможно, пойду
      static func statusMaybeFull(_: Void = ()) -> String {
        return NSLocalizedString("status.maybe.full", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Все события
      static func eventsListTitle(_: Void = ()) -> String {
        return NSLocalizedString("eventsList.title", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Не пойду
      static func statusDeclinedFull(_: Void = ()) -> String {
        return NSLocalizedString("status.declined.full", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Не пойду
      static func statusDeclinedShort(_: Void = ()) -> String {
        return NSLocalizedString("status.declined.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Опоздаю
      static func statusLateShort(_: Void = ()) -> String {
        return NSLocalizedString("status.late.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Опоздаю на %d мин
      static func statusLateFull(_ value1: Int) -> String {
        return String(format: NSLocalizedString("status.late.full", bundle: R.hostingBundle, comment: ""), locale: R.applicationLocale, value1)
      }
      
      /// Value: Отказался
      static func eventsListSectionsDeclined(_: Void = ()) -> String {
        return NSLocalizedString("eventsList.sections.declined", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Пойду
      static func statusAcceptedShort(_: Void = ()) -> String {
        return NSLocalizedString("status.accepted.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Приглашен
      static func eventsListSectionsInvited(_: Void = ()) -> String {
        return NSLocalizedString("eventsList.sections.invited", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Приглашен
      static func statusUnknownFull(_: Void = ()) -> String {
        return NSLocalizedString("status.unknown.full", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Приглашен
      static func statusUnknownShort(_: Void = ()) -> String {
        return NSLocalizedString("status.unknown.short", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Приду вовремя
      static func statusAcceptedFull(_: Void = ()) -> String {
        return NSLocalizedString("status.accepted.full", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Приду вовремя
      static func statusOntimeFull(_: Void = ()) -> String {
        return NSLocalizedString("status.ontime.full", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _ActiveEventCell.validate()
    }
    
    struct _ActiveEventCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType, Rswift.Validatable {
      typealias ReusableType = ActiveEventCell
      
      let bundle = R.hostingBundle
      let identifier = "ActiveEventCell"
      let name = "ActiveEventCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> ActiveEventCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ActiveEventCell
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "common.arrowDown", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'common.arrowDown' is used in nib 'ActiveEventCell', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
          if UIKit.UIColor(named: "block", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'block' is used in storyboard 'ActiveEventCell', but couldn't be loaded.") }
          if UIKit.UIColor(named: "shape.background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'shape.background' is used in storyboard 'ActiveEventCell', but couldn't be loaded.") }
          if UIKit.UIColor(named: "text.primary", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'text.primary' is used in storyboard 'ActiveEventCell', but couldn't be loaded.") }
        }
      }
      
      fileprivate init() {}
    }
    
    struct _AvatarView: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "AvatarView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }
      
      fileprivate init() {}
    }
    
    struct _EventCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = EventCell
      
      let bundle = R.hostingBundle
      let identifier = "EventCell"
      let name = "EventCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> EventCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? EventCell
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try eventsList.validate()
      try launchScreen.validate()
    }
    
    struct eventsList: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = EventsListViewController
      
      let bundle = R.hostingBundle
      let eventsListViewController = StoryboardViewControllerResource<EventsListViewController>(identifier: "EventsListViewController")
      let name = "EventsList"
      
      func eventsListViewController(_: Void = ()) -> EventsListViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: eventsListViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
          if UIKit.UIColor(named: "background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'background' is used in storyboard 'EventsList', but couldn't be loaded.") }
        }
        if _R.storyboard.eventsList().eventsListViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'eventsListViewController' could not be loaded from storyboard 'EventsList' as 'EventsListViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
          if UIKit.UIColor(named: "background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'background' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
