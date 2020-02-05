//
//  Router.swift
//  Cooplay
//
//  Created by Alexandr on 04/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import LightRoute

protocol Router: class {
    
    var transitionHandler: TransitionHandler! { get set }
}
