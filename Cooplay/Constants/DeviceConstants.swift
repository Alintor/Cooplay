//
//  DeviceConstants.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

enum DeviceConstants {
    
    static var screenWidth: CGFloat = UIApplication.shared.statusBarFrame.size.width
    static var isSmallScreen: Bool {
        return screenWidth < 370.0
    }
}
