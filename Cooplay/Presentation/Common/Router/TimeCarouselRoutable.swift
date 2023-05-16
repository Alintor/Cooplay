//
//  TimeCarouselRoutable.swift
//  Cooplay
//
//  Created by Alexandr on 18/01/2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import UIKit

protocol TimeCarouselRoutable: Router {
    
    func showCarousel(delegate: TimeCarouselContextDelegate?, configuration: TimeCarouselConfiguration, selectHandler: ((_ date: Date) -> Void)?)
}

extension TimeCarouselRoutable {
    
    func showCarousel(delegate: TimeCarouselContextDelegate?, configuration: TimeCarouselConfiguration, selectHandler: ((_ date: Date) -> Void)?) {
        guard let delegate = delegate ?? rootViewController as? TimeCarouselContextDelegate else { return }
        let contextView = TimeCarouselContextView(configuration: configuration, delegate: delegate, selectHandler: selectHandler)
        contextView.show()
    }
}
