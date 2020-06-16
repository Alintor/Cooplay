//
//  PersonalisationInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

enum PersonalisationError: Error {
    
    case invalidNickName(message: String)
    case unhandled(error: Error)
}

extension PersonalisationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidNickName(let message): return message
        case .unhandled(let error):
            return error.localizedDescription
        }
    }
}

final class PersonalisationInteractor {
    
    private enum Constant {
        
        static let minSymbols = 2
        static let maxSymbols = 12
        static let wrongSymbol = " "
    }

}

// MARK: - PersonalisationInteractorInput

extension PersonalisationInteractor: PersonalisationInteractorInput {

    func validateNickName(_ nickname: String) -> PersonalisationError? {
        if nickname.count < Constant.minSymbols {
            return .invalidNickName(message: R.string.localizable.personalisationErrorNicknameMinSymbols(Constant.minSymbols))
        }
        if nickname.count > Constant.maxSymbols {
            return .invalidNickName(message: R.string.localizable.personalisationErrorNicknameMaxSymbols(Constant.maxSymbols))
        }
        if nickname.contains(Constant.wrongSymbol) {
            return .invalidNickName(message: R.string.localizable.personalisationErrorNicknameSpace())
        }
        return nil
    }
    
    func setNickname(_ nickname: String, completion: @escaping (Result<Void, PersonalisationError>) -> Void) {
        completion(.success(()))
    }
}
