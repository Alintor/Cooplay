//
//  APIRequestSpecification.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Moya

public protocol APIRequestSpecification: TargetType {
    
    var requiresAuthorization: Bool { get }
}

public extension APIRequestSpecification {
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
}
