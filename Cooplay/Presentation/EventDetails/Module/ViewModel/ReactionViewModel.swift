//
//  ReactionViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 19.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation

struct ReactionViewModel {
    
    let user: User
    
    var avatarViewModel: AvatarViewModel
    var value: String
    var isOwner: Bool
    
    init(user: User, value: String, isOwner: Bool) {
        self.user = user
        avatarViewModel = AvatarViewModel(with: user)
        self.value = value
        self.isOwner = isOwner
    }
    
    static func build(reactions: [String: Reaction], event: Event) -> [ReactionViewModel] {
        
        var viewModels = [ReactionViewModel]()
        
        for (userId, reaction) in reactions {
            guard reaction.style != .unknown else { continue }
            
            if userId == event.me.id {
                viewModels.append(ReactionViewModel(user: event.me, value: reaction.value, isOwner: true))
                continue
            }
            for member in event.members {
                if userId == member.id {
                    viewModels.append(ReactionViewModel(user: member, value: reaction.value, isOwner: false))
                    break
                }
            }
        }
        return viewModels.sorted(by: { $0.user.name < $1.user.name }).sorted(by: { $0.isOwner == true && $1.isOwner != true})
    }
    
}
