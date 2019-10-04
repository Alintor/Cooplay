//
//  UIImageView.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(withPath path: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: path) else { return }
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
