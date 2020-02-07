//
//  AuthorizationHandler.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

protocol AuthorizationHandlerType {
    
    var isAuthorized: Bool { get }
    func unauthorize()
    func authenticateRequest(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void)
}

final class AuthorizationHandler {
    
}

extension AuthorizationHandler: AuthorizationHandlerType {
    
    func authenticateRequest(_ request: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
    }
    
    var isAuthorized: Bool {
        return true
    }
    
    func unauthorize() {
        
    }
}
