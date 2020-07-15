//
//  SearchMembersInteractor.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Foundation
import FirebaseDynamicLinks

enum SearchMembersError: Error {
    
    case unhandled(error: Error)
}

extension SearchMembersError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let error): return error.localizedDescription
        }
    }
}

final class SearchMembersInteractor {

    private let userService: UserServiceType?
    
    init(userService: UserServiceType?) {
        self.userService = userService
    }
}

// MARK: - SearchMembersInteractorInput

extension SearchMembersInteractor: SearchMembersInteractorInput {

    func searchMember(_ searchValue: String, completion: @escaping (Result<[User], SearchMembersError>) -> Void) {
        userService?.searchUser(searchValue) { result in
            switch result {
            case .success(let members):
                completion(.success(members))
            case .failure(let error):
                completion(.failure(.unhandled(error: error)))
            }
        }
    }
    
    func generateInviteLink(eventId: String, completion: @escaping (_ url: URL) -> Void) {
        let link = URL(string: "\(AppConfiguration.officialSite)event?\(GlobalConstant.eventIdKey)=\(eventId)")!
        let dynamicLinksDomainURIPrefix = AppConfiguration.dynamicLinkDomain
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: AppConfiguration.bundleID)
        linkBuilder?.iOSParameters?.customScheme = AppConfiguration.dynamicLinkCustomScheme
        linkBuilder?.iOSParameters?.appStoreID = AppConfiguration.appleAppId
        linkBuilder?.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
        linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true
        linkBuilder?.shorten(completion: { (url, _, _) in
            if let url = url {
                completion(url)
            }
        })
    }
}
