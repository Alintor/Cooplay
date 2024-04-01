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
        
        if data.count > maxSize && quality > 0.1 {
            let nextQuality = quality - 0.05
            if nextQuality < 0.1 {
                return self.reduce(maxSize: maxSize, quality: 0.1)
            } else {
                return self.reduce(maxSize: maxSize, quality: nextQuality)
            }
        }
        return data
    }
}
