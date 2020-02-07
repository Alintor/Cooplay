//
//  APIProvider.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Moya

protocol APIProviderType {
    
    var isAuthorized: Bool { get }
    
    func unauthorize()
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, MoyaError>) -> Void
    )
    func sendRequest<T: APIRequestSpecification>(
        requestSpecification: T,
        completion: @escaping (Result<Void, MoyaError>) -> Void
    )
}

class APIProvider {
    
    private var provider: MoyaProvider<MultiTarget>?
    private let authorizationHandler: AuthorizationHandlerType?
    private let responseDecoder: JSONDecoder
    
    // MARK: - Init
    
    init(
        apiKey: String,
        authorizationHandler: AuthorizationHandlerType?,
        defaultHeaders: [String: String],
        responseDecoder: JSONDecoder = JSONDecoder(),
        callbackQueue: DispatchQueue? = DispatchQueue.main) {
        self.authorizationHandler = authorizationHandler
        self.responseDecoder = responseDecoder
        
        // Append default headers
        let endpointClosure = { (target: MultiTarget) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            var additionalHeaders = defaultHeaders
            switch target.target {
            case let target as APIRequestSpecification:
                // If target doesn't require auth token, provide default api key
                if !target.requiresAuthorization { additionalHeaders["Authorization"] = apiKey }
            default:
                break
            }
            target.headers?.forEach { additionalHeaders[$0] = $1 }
            return defaultEndpoint.adding(newHTTPHeaderFields: additionalHeaders)
        }
        
        // Authorize requests if needed
        let requestClosure = { [weak self] (endpoint: Endpoint, completion: @escaping (Result<URLRequest, MoyaError>) -> Void) in
            if let urlRequest = try? endpoint.urlRequest() {
                if let headers = endpoint.httpHeaderFields, headers["Authorization"] != nil {
                    // Unauthorized requests
                    completion(.success(urlRequest))
                } else {
                    // Authorized requests
                    self?.authorizationHandler?.authenticateRequest(urlRequest) { result in
                        switch result {
                        case .success(let authenticatedURLRequest):
                            completion(.success(authenticatedURLRequest))
                        case .failure(let error):
                            completion(.failure(.underlying(error, nil)))
                        }
                    }
                }
            }
        }
        
        self.provider = MoyaProvider<MultiTarget>(
            endpointClosure: endpointClosure,
            requestClosure: { endpoint, completion in
                requestClosure(endpoint) { result in
                    switch result {
                    case .success(let urlRequest): completion(.success(urlRequest))
                    case .failure(let error): completion(.failure(error))
                    }
                }
            },
            callbackQueue: callbackQueue,
            plugins: []
        )
    }
}

extension APIProvider: APIProviderType {
    
    var isAuthorized: Bool {
        return authorizationHandler?.isAuthorized ?? false
    }
    
    func unauthorize() {
        authorizationHandler?.unauthorize()
    }
    
    func authenticateRequest(
        _ urlRequest: URLRequest,
        mainQueue: Bool = true,
        completion: @escaping (Result<URLRequest, MoyaError>) -> Void) {
        authorizationHandler?.authenticateRequest(urlRequest) { result in
            func handleResult() {
                switch result {
                case .success(let signedURLRequest):
                    completion(.success(signedURLRequest))
                case .failure(let error):
                    completion(.failure(.underlying(error, nil)))
                }
            }
            if mainQueue {
                DispatchQueue.main.async {
                    handleResult()
                }
            } else {
                handleResult()
            }
        }
    }
    
    
    func sendRequest<T: APIRequestSpecification, ResponseDataType: Decodable>(
        requestSpecification: T,
        completion: @escaping (Result<ResponseDataType, MoyaError>) -> Void) {
        guard let provider = provider else { return }
        provider.request(MultiTarget(requestSpecification)) { [weak self] result in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                switch result {
                case let .success(response):
                    do {
                        completion(.success(try response.map(ResponseDataType.self, using: self.responseDecoder)))
                    } catch let error {
                        completion(.failure(.objectMapping(error, response)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func sendRequest<T: APIRequestSpecification>(
        requestSpecification: T,
        completion: @escaping (Result<Void, MoyaError>) -> Void) {
        guard let provider = provider else { return }
        provider.request(MultiTarget(requestSpecification)) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion(.success(()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }
}
