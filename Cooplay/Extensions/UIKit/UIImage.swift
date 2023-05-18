//
//  UIImage.swift
//  Cooplay
//
//  Created by Alexandr on 17.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIImage {
    
    var imageDataForUpload: Data? {
        reduce(maxSize: 400000, quality: 1)
    }
    
    func reduce(maxSize: Int, quality: CGFloat) -> Data? {
        guard let data = self.jpegData(compressionQuality: quality) else { return nil }
        
        let size = data.count
        if data.count > maxSize {
            let nextQuality = quality - 0.05
            if nextQuality < 0.0 {
                return data
            } else {
                return self.reduce(maxSize: maxSize, quality: nextQuality)
            }
        }
        return data
    }
}
