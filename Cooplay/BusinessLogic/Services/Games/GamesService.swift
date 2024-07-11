//
//  GamesService.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

enum GamesServiceError: Error {
    
    case unhandled(error: Error)
}

extension GamesServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

protocol GamesServiceType {
    
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void)
    func searchGame(_ searchValue: String) async throws -> [Game]
}


final class GamesService {
    
    private let provider: APIProviderType?
    private let defaultsStorage: DefaultsStorageType?
    
    init(provider: APIProviderType?, defaultsStorage: DefaultsStorageType?) {
        self.provider = provider
        self.defaultsStorage = defaultsStorage
    }
}

extension GamesService: GamesServiceType {
    
    func searchGame(_ searchValue: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void) {
        if
            let tokenData = defaultsStorage?.get(valueForKey: .gameDBToken) as? Data,
            let token = try? JSONDecoder().decode(GameDBToken.self, from: tokenData),
            token.expiresAt > Date() {
            fetchGames(searchValue: searchValue, token: token.token, completion: completion)
        } else {
            fetchToken { [weak self] result in
                switch result {
                case .success(let token):
                    self?.fetchGames(searchValue: searchValue, token: token, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func searchGame(_ searchValue: String) async throws -> [Game] {
        if
            let tokenData = defaultsStorage?.get(valueForKey: .gameDBToken) as? Data,
            let token = try? JSONDecoder().decode(GameDBToken.self, from: tokenData),
            token.expiresAt > Date() 
        {
            return try await fetchGames(searchValue: searchValue, token: token.token)
        } else {
            let token = try await fetchToken()
            return try await fetchGames(searchValue: searchValue, token: token)
        }
    }
    
    private func fetchGames(searchValue: String, token: String, completion: @escaping (Result<[Game], GamesServiceError>) -> Void) {
        provider?.sendRequest(requestSpecification: GamesSpecification.search(value: searchValue, accessToken: token)
        ) { (result: Result<JSON, MoyaError>) in
            switch result {
            case .success(let response):
                let games = response.array?.map({ Game(with: $0)})
                completion(.success(games ?? []))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    private func fetchGames(searchValue: String, token: String) async throws -> [Game] {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.provider?.sendRequest(requestSpecification: GamesSpecification.search(value: searchValue, accessToken: token)
            ) { (result: Result<JSON, MoyaError>) in
                switch result {
                case .success(let response):
                    let games = response.array?.map({ Game(with: $0)})
                    continuation.resume(returning: games ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func fetchToken(completion: @escaping (Result<String, GamesServiceError>) -> Void) {
        provider?.sendRequest(requestSpecification: GamesSpecification.token) { [weak self] (result: Result<GameDBToken, MoyaError>) in
            switch result {
            case .success(let token):
                if let tokenData = try? JSONEncoder().encode(token) {
                    self?.defaultsStorage?.set(value: tokenData, forKey: .gameDBToken)
                }
                completion(.success(token.token))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    private func fetchToken() async throws -> String {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.provider?.sendRequest(requestSpecification: GamesSpecification.token) { [weak self] (result: Result<GameDBToken, MoyaError>) in
                switch result {
                case .success(let token):
                    if let tokenData = try? JSONEncoder().encode(token) {
                        self?.defaultsStorage?.set(value: tokenData, forKey: .gameDBToken)
                    }
                    continuation.resume(returning: token.token)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
