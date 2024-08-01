//
//  SearchMembersState.swift
//  Cooplay
//
//  Created by Alexandr on 12.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation
import FirebaseDynamicLinks

struct ShareInfo: Identifiable {
    let id: UUID = .init()
    let url: URL
}

class SearchMembersState: ObservableObject {
    
    // MARK: - Properties
    
    private let eventService: EventServiceType
    private let userService: UserServiceType
    @Published var oftenMembers: [User]?
    @Published var searchResultMembers: [User]?
    @Published var showSkeleton: Bool = false
    @Published var showProgress: Bool = false
    @Published var selectedMembers: [User]
    @Published var shareInfo: ShareInfo?
    var selectedMembersViewModels: [NewEventMemberCellViewModel] {
        selectedMembers.map { user in
            NewEventMemberCellViewModel(model: user, isSelected: true, isBlocked: blockedMembers.contains(where: { $0 == user }), selectAction: nil)
        }
    }
    var oftenMembersViewModels: [NewEventMemberCellViewModel]? {
        oftenMembers?.map({ user in
            NewEventMemberCellViewModel(
                model: user,
                isSelected: selectedMembers.contains(where: { $0 == user }),
                isBlocked: blockedMembers.contains(where: { $0 == user }),
                selectAction: nil
            )
        })
    }
    var searchResultMembersViewModels: [NewEventMemberCellViewModel]? {
        searchResultMembers?.map({ user in
            NewEventMemberCellViewModel(
                model: user,
                isSelected: selectedMembers.contains(where: { $0 == user }),
                isBlocked: blockedMembers.contains(where: { $0 == user }),
                selectAction: nil
            )
        })
    }
    private let blockedMembers: [User]
    private var resultMembers: [User] {
        selectedMembers.filter { user in
            !blockedMembers.contains { $0 == user}
        }
    }
    var isDoneDisabled: Bool {
        resultMembers.isEmpty
    }
    let eventId: String
    var close: (() -> Void)?
    private var selectionHandler: ((_ members: [User]) -> Void)?
    
    // MARK: - Init
    
    init(
        eventId: String,
        eventService: EventServiceType,
        userService: UserServiceType,
        oftenMembers: [User]?,
        selectedMembers: [User]?,
        isEditing: Bool,
        selectionHandler: ((_ members: [User]) -> Void)?
    ) {
        self.eventId = eventId
        self.eventService = eventService
        self.userService = userService
        self.selectionHandler = selectionHandler
        self.selectedMembers = selectedMembers ?? []
        blockedMembers = isEditing ? selectedMembers ?? [] : []
        self.oftenMembers = oftenMembers
    }
    
    // MARK: - Methods
    
    func tryFetchOftenDataIfNeeded() {
        guard oftenMembers == nil else { return }
        
        Task {
            do {
                let data = try await eventService.fetchOftenData()
                await MainActor.run {
                    oftenMembers = data.members
                }
            } catch {
                await MainActor.run {
                    oftenMembers = []
                }
            }
        }
    }
    
    func searchMember(name: String) {
        guard name.count >= 3 else { return }
        
        showSkeleton = true
        Task {
            do {
                let members = try await userService.searchUser(name)
                await MainActor.run {
                    showSkeleton = false
                    searchResultMembers = members
                }
            } catch {
                await MainActor.run {
                    showSkeleton = false
                    searchResultMembers = []
                }
            }
        }
    }
    
    func didSelectMember(_ member: User) {
        if let index = selectedMembers.firstIndex(where: { $0 == member }) {
            selectedMembers.remove(at: index)
        } else {
            selectedMembers.insert(member, at: 0)
        }
    }
    
    func didTapInviteByLink() {
        showProgress = true
        let link = URL(string: "\(GlobalConstant.webLink)/invite?\(GlobalConstant.eventIdKey)=\(eventId)")!
        let dynamicLinksDomainURIPrefix = AppConfiguration.dynamicLinkDomain
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: AppConfiguration.bundleID)
        linkBuilder?.iOSParameters?.customScheme = AppConfiguration.dynamicLinkCustomScheme
        linkBuilder?.iOSParameters?.appStoreID = GlobalConstant.appleAppId
        linkBuilder?.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
        linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true
        Task {
            do {
                let result = try await linkBuilder?.shorten()
                await MainActor.run {
                    showProgress = false
                    if let url = result?.0 {
                        shareInfo = .init(url: url)
                    }
                }
            } catch {
                await MainActor.run {
                    showProgress = false
                    searchResultMembers = []
                }
            }
        }
    }
    
    func didTapDoneButton() {
        selectionHandler?(resultMembers)
        close?()
    }
    
}
