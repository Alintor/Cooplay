//
//  HardcodedStorage.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

enum HardcodedConstants {
    
    static let overwatch = Game(
        slug: "overwatch",
        name: "Overwatch",
        imagePath: "https://media.rawg.io/media/games/4ea/4ea507ceebeabb43edbc09468f5aaac6.jpg"
    )
    static let destiny = Game(
        slug: "destiny-2",
        name: "Destiny 2",
        imagePath: "https://media.rawg.io/media/games/1d5/1d553996f8c07c06d5f5e526c65d33a4.jpg"
    )
    static let apex = Game(
        slug: "apex-legends",
        name: "Apex Legends",
        imagePath: "https://media.rawg.io/media/games/b72/b7233d5d5b1e75e86bb860ccc7aeca85.jpg"
    )
    static let divinity = Game(
        slug: "divinity-original-sin-2",
        name: "Divinity: Original Sin 2",
        imagePath: "https://media.rawg.io/media/games/424/424facd40f4eb1f2794fe4b4bb28a277.jpg"
    )
    
    static let me_ontime = User(id: "daffhdfgd", name: "Alintor", avatarPath: nil, state: .accepted, lateness: 0)
    static let me_unknown = User(id: "daffhdfgd", name: "Alintor", avatarPath: nil, state: .unknown, lateness: nil)
    static let me_late = User(id: "daffhdfgd", name: "Alintor", avatarPath: nil, state: .accepted, lateness: 15)
    static let me_maybe = User(id: "daffhdfgd", name: "Alintor", avatarPath: nil, state: .maybe, lateness: nil)
    static let nilo_ontime = User(id: "jhdfgsd", name: "Zharmakin", avatarPath: nil, state: .accepted, lateness: 0)
    static let nilo_late = User(id: "jhdfgsd", name: "Zharmakin", avatarPath: nil, state: .accepted, lateness: 15)
    static let nilo_decline = User(id: "jhdfgsd", name: "Zharmakin", avatarPath: nil, state: .declined, lateness: nil)
    static let madik_ontime = User(id: "tyiiyoir", name: "Madik_b", avatarPath: nil, state: .accepted, lateness: 0)
    static let madik_decline = User(id: "tyiiyoir", name: "Madik_b", avatarPath: nil, state: .declined, lateness: nil)
    static let madik_maybe = User(id: "tyiiyoir", name: "Madik_b", avatarPath: nil, state: .maybe, lateness: nil)
    static let rika_ontime = User(id: "cvnbvjl", name: "Rika_Aga", avatarPath: nil, state: .accepted, lateness: 0)
    static let rika_maybe = User(id: "cvnbvjl", name: "Rika_Aga", avatarPath: nil, state: .maybe, lateness: nil)
    static let random1 = User(id: "cvnvrdger", name: "Dude", avatarPath: nil, state: .accepted, lateness: 0)
    static let random2 = User(id: "tryuyrteruy", name: "Lalka", avatarPath: nil, state: .accepted, lateness: 0)
    static let random3 = User(id: "bnhgdfjghs", name: "Nagibator", avatarPath: nil, state: .accepted, lateness: 0)
    static let random4 = User(id: "fghrgjbvccssew", name: "Boom", avatarPath: nil, state: .accepted, lateness: nil)
    
    static let eventInvitation1 = Event(
        game: divinity,
        date: "2019-10-29 20:30:00".convertServerDate!,
        members: [nilo_ontime, rika_ontime],
        me: me_unknown
    )
    static let eventInvitation2 = Event(
        game: overwatch,
        date: "2019-11-02 22:15:00".convertServerDate!,
        members: [nilo_ontime, rika_ontime, madik_maybe],
        me: me_unknown
    )
    static let eventNow = Event(
        game: overwatch,
        date: "2019-10-4 21:00:00".convertServerDate!,
        members: [nilo_late, rika_ontime, madik_maybe],
        me: me_ontime
    )
    static let eventFuture1 = Event(
        game: apex,
        date: "2019-10-5 22:00:00".convertServerDate!,
        members: [nilo_ontime, rika_ontime],
        me: me_late
    )
    static let eventFuture2 = Event(
        game: destiny,
        date: "2019-10-19 21:10:00".convertServerDate!,
        members: [nilo_ontime, rika_maybe, madik_ontime],
        me: me_ontime
    )
    static let eventFuture3 = Event(
        game: overwatch,
        date: "2019-10-25 22:45:00".convertServerDate!,
        members: [nilo_ontime, rika_ontime, madik_maybe, random1, random4, random2],
        me: me_maybe
    )
}

final class HardcodedStorage {
    
    private var events = [
        HardcodedConstants.eventInvitation1,
        HardcodedConstants.eventInvitation2,
        HardcodedConstants.eventNow,
        HardcodedConstants.eventFuture1,
        HardcodedConstants.eventFuture2,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3,
        HardcodedConstants.eventFuture3
    ]
    
    func fetchEvents() -> [Event] {
        return events
    }
}
