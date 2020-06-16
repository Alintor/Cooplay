//
//  RegistrationField.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

enum RegistrationField {
    
    case email(value: String?)
    case password(value: String?)
    case confirmPassword(value: String?)
}
