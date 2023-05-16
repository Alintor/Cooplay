//
//  GuestRoutable.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol GuestRoutable {
    
    func openIntro()
}

extension GuestRoutable {
    
    func openIntro() {
        UIApplication.setRootViewController(IntroBuilder().build())
    }
}
