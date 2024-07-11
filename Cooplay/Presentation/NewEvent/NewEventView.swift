//
//  NewEventView.swift
//  Cooplay
//
//  Created by Alexandr on 26.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventView: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var homeCoordinator: HomeCoordinator
    @StateObject var state: NewEventState
    @State var showTimeContext = false
    @State var showCalendar = false
    @State var showSearchMember = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    gamesView
                    Divider()
                    daysView
                    Divider()
                    timeView
                    Divider()
                    membersView
                }
                .padding(.vertical, 72)
            }
            VStack() {
                ProfileNavigationView(title: Localizable.newEventTitle(), isBackButton: .constant(true)) {
                    homeCoordinator.showNewEvent = false
                }
                .background {
                    if homeCoordinator.showNewEvent {
                        TransparentBlurView(removeAllFilters: false)
                            .blur(radius: 15)
                            .padding([.horizontal, .top], -30)
                            .frame(width: UIScreen.main.bounds.size.width)
                            .ignoresSafeArea()
                    }
                }
                Spacer()
            }
            VStack {
                Spacer()
                MainActionButton(Localizable.newEventMainActionTitle(), isDisabled: !state.isReady) {
                    state.tryCreateEvent()
                }
                .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .opacity(homeCoordinator.showNewEvent ? 1 : 0)
                .background {
                    TransparentBlurView(removeAllFilters: false)
                        .blur(radius: 15)
                        .padding([.horizontal, .bottom], -30)
                        .frame(width: UIScreen.main.bounds.size.width)
                        .ignoresSafeArea()
                }
            }
            if showTimeContext, let timeDate = state.date {
                NewEventContextTimeView(showTimeContext: $showTimeContext, timeDate: timeDate)
                    .zIndex(10)
                    .environmentObject(state)
            }
            if showCalendar, let date = state.date {
                NewEventCalendarView(showCalendar: $showCalendar, date: date)
                    .environmentObject(state)
                    .zIndex(10)
            }
            
        }
        .sheet(isPresented: $showSearchMember, content: {
            SearchMembersView(
                eventId: state.eventId,
                selectedMembers: state.members?.filter({ $0.isSelected }).map({ $0.model }) ?? [],
                oftenMembers: state.members?.compactMap({ $0.model }),
                isEditing: false
            ) { members in
                state.didSelectMembers(members)
            }
        })
        .animation(.stackTransition, value: state.dayDate)
        .animation(.stackTransition, value: state.games)
        .animation(.stackTransition, value: state.members)
        .animation(.customTransition, value: showTimeContext)
        .animation(.customTransition, value: showCalendar)
        .animation(.customTransition, value: state.showProgress)
        .animation(.customTransition, value: state.date)
        .onAppear {
            state.close = {
                homeCoordinator.showNewEvent = false
            }
            state.tryFetchOftenData()
        }
    }
    
    // MARK: - Games
    
    var gamesView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Localizable.newEventChooseGameLabelTitle())
                    .foregroundStyle(Color(.textSecondary))
                    .font(.system(size: 20))
                Spacer()
                Button(Localizable.newEventSearchGameButtonTitle()) {
                    AnalyticsService.sendEvent(.openSearchGameFromNewEvent)
                    homeCoordinator.showSheetModal(HomeCoordinator.SheetModal.searchGame(
                        oftenGames: state.games?.compactMap({ $0.model }),
                        selectedGame: state.games?.first(where: { $0.isSelected })?.model,
                        selectionHandler: { game in
                            state.didSelectGame(game)
                        }
                    ))
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 20))
            }
            .padding(.horizontal, 24)
            if let games = state.games {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader{ scroll in
                        HStack(spacing: 16) {
                            ForEach(games, id:\.model.slug) { item in
                                NewEventGameItemView(model: item)
                                    .onTapGesture {
                                        Haptic.play(style: .medium)
                                        state.didSelectGame(item.model)
                                    }
                            }
                        }
                        .padding(.horizontal, 24)
                        .onReceive(state.$games) { games in
                            guard let selectedGame = games?.first(where: { $0.isSelected }) else { return }
                            withAnimation {
                                scroll.scrollTo(selectedGame.model.slug)
                            }
                        }
                    }
                }
            } else {
                NewEventSkeletonGamesView()
            }
        }
        .padding(.bottom, 22)
    }
    
    // MARK: - Day
    
    var daysView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Localizable.newEventChooseDayLabelTitle())
                    .foregroundStyle(Color(.textSecondary))
                    .font(.system(size: 20))
                Spacer()
            }
            HStack(spacing: 12) {
                dayButton(title: Localizable.newEventTodayButtonTitle(), isSelected: state.dayDate == .today) {
                    state.didSelectDay(.today)
                }
                dayButton(title: Localizable.newEventTomorrowButtonTitle(), isSelected: state.dayDate == .tomorrow) {
                    state.didSelectDay(.tomorrow)
                }
                if case .custom(let model) = state.dayDate {
                    calendarButton(model: model)
                        .onTapGesture { showCalendar = true }
                } else {
                    emptyCalendarView
                        .onTapGesture { showCalendar = true }
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    func dayButton(title: String, isSelected: Bool, action: (() -> Void)?) -> some View {
        Text(title)
            .font(.system(size: 20))
            .colorMultiply(Color(isSelected ? .textPrimary : .actionAccent))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(.block))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .addBorder(Color(.background), width: isSelected ? 4 : 0, cornerRadius: 16)
            .addBorder(Color(.actionAccent), width: isSelected ? 2 : 0, cornerRadius: 16)
            .onTapGesture {
                Haptic.play(style: .medium)
                action?()
            }
    }
    
    var emptyCalendarView: some View {
        Image(.commonCalendar)
            .foregroundStyle(Color(.actionAccent))
            .frame(width: 24, height: 24)
            .padding(16)
            .background(Color(.block))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
    
    func calendarButton(model: NewEventDayDateViewModel) -> some View {
        VStack(spacing: 0) {
            Text(model.day)
                .foregroundStyle(Color(.textPrimary))
                .font(.system(size: 20))
            Text(model.month)
                .foregroundStyle(Color(.textPrimary))
                .font(.system(size: 17))
                .padding(.top, -4)
        }
        .frame(width: 56, height: 56)
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .addBorder(Color(.background), width: 4, cornerRadius: 16)
        .addBorder(Color(.actionAccent), width: 2, cornerRadius: 16)
    }
    
    // MARK: - Time
    
    var timeView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Localizable.newEventChooseTimeLabelTitle())
                    .foregroundStyle(Color(.textSecondary))
                    .font(.system(size: 20))
                Spacer()
            }
            if let date = state.date {
                NewEventTimeView(timeValue: date.timeDisplayString, isOpened: false)
                    .matchedGeometryEffect(id: MatchedAnimations.timeView.name, in: namespace.id)
                    .onTapGesture { showTimeContext = true }
            } else {
                Rectangle()
                    .fill(Color(.block))
                    .frame(height: 56)
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .shimmer()
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
    
    // MARK: - Members
    
    var membersView: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Localizable.newEventChooseMembersLabelTitle())
                    .foregroundStyle(Color(.textSecondary))
                    .font(.system(size: 20))
                Spacer()
                Button(Localizable.newEventSearchMembersButtonTitle()) {
                    AnalyticsService.sendEvent(.openSearchMemberFromNewEvent)
                    showSearchMember = true
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 20))
            }
            .padding(.horizontal, 24)
            if let members = state.members {
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollViewReader{ scroll in
                        HStack(spacing: 2) {
                            ForEach(members, id:\.model.id) { item in
                                NewEventMemberItemView(model: item)
                                    .onTapGesture {
                                        Haptic.play(style: .medium)
                                        state.didSelectMember(item.model)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .onReceive(state.$members) { members in
                            guard let firstSelectedMember = members?.first(where: { $0.isSelected }) else { return }
                            withAnimation {
                                scroll.scrollTo(firstSelectedMember.model.id)
                            }
                        }
                    }
                }
            } else {
                NewEventSkeletonMembersView()
            }
        }
        .padding(.vertical, 16)
    }
}
