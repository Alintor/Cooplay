//
//  NSObject.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation

extension NSObjectProtocol {

    @discardableResult
    func with(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

}
