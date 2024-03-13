//
//  Validation.swift
//  Cooplay
//
//  Created by Alexandr on 12.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

enum Validation {
    
    static func password(_ password: String) -> [PasswordValidation] {
        guard !password.isEmpty else {
            return [.minLength(isValid: nil), .capitalLetter(isValid: nil), .digit(isValid: nil)]
        }
        
        var types = [PasswordValidation]()
        types.append(.minLength(isValid: password.count >= GlobalConstant.Format.passwordMinLength))
        var hasNumeric = false
        var hasBigSymbol = false
        for character in password {
            if GlobalConstant.Format.numericSymbols.contains(character) {
                hasNumeric = true
            }
            if character.isUppercase {
                hasBigSymbol = true
            }
        }
        types.append(.capitalLetter(isValid: hasBigSymbol))
        types.append(.digit(isValid: hasNumeric))
        return types
    }
}
