//
//  EmptyStateHandler.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

struct EmptyStateHandler {
    
    let image: UIImage?
    private let title: String
    private let descriptionText: String?
    
    // MARK: - Appearance
    
    public struct Appearance {
        
        public struct Text {
            
            public let font: UIFont
            public let color: UIColor
            
            // MARK: - Init
            
            public init(
                font: UIFont,
                color: UIColor) {
                self.font = font
                self.color = color
            }
        }
        
        public let title: Text
        public let description: Text
        
        public static var defaultAppearance: Appearance {
            return Appearance(
                title: Text(
                    font: UIFont.systemFont(ofSize: 20, weight: .medium),
                    color: R.color.textPrimary()!
                ),
                description: Text(
                    font: UIFont.systemFont(ofSize: 17),
                    color: R.color.textSecondary()!
                )
            )
        }
        
        // MARK: - Init
        
        public init(
            title: Text,
            description: Text) {
            self.title = title
            self.description = description
        }
    }
    
    var appearance: Appearance {
        return Appearance.defaultAppearance
    }
    
    // MARK: - Init
    
    init(
        image: UIImage? = nil,
        title: String,
        descriptionText: String? = nil) {
        self.image = image
        self.title = title
        self.descriptionText = descriptionText
    }
    
    // MARK: - Interface
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return image
    }
    
    var attributedTitle: NSAttributedString! {
        return NSAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font: appearance.title.font,
                NSAttributedString.Key.foregroundColor: appearance.title.color
            ]
        )
    }
    
    var attributedDescription: NSAttributedString! {
        guard let descriptionText = descriptionText else { return nil }
        return NSAttributedString(
            string: descriptionText,
            attributes: [
                NSAttributedString.Key.font: appearance.description.font,
                NSAttributedString.Key.foregroundColor: appearance.description.color
            ]
        )
    }
    
}
