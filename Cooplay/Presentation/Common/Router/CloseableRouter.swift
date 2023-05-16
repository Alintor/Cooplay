//
//  CloseableRouter.swift
//  Cooplay
//
//  Created by Alexandr on 04/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//


protocol CloseableRouter: Router {
    
    func close(animated: Bool)
}

extension CloseableRouter {
    
    func close(animated: Bool) {
        rootViewController?.close()
    }
}
