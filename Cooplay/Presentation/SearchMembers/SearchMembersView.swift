//
//  SearchMembersView.swift
//  Cooplay
//
//  Created by Alexandr on 12.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMembersView: View {
    
    @StateObject var state: SearchMembersState
    @EnvironmentObject var homeCoordinator: HomeCoordinator
    @State var searchInput = ""
    
    var body: some View {
        ZStack {
            Color(.background)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack {
                    navigationBar
                    SearchField(text: $searchInput, placeholder: Localizable.searchMembersSearchBarPlaceholder())
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                        .disabled(state.showProgress)
                        .onChange(of: searchInput) { newValue in
                            if newValue.isEmpty {
                                state.searchResultMembers = nil
                            }
                        }
                        .onSubmit {
                            state.searchMember(name: searchInput)
                        }
                }
                .background(Color(.block))
                if !state.selectedMembersViewModels.isEmpty {
                    VStack(spacing: 8) {
                        selectedMembersView
                            .padding(.top, 12)
                        separator
                    }
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
                if state.showSkeleton {
                    SearchMembersSkeletonView(title: Localizable.searchGameSectionsSearchResults())
                        .transition(.opacity)
                } else if let resultMembers = state.searchResultMembersViewModels {
                    if resultMembers.isEmpty {
                        SearchMembersEmptyResultView { state.didTapInviteByLink() }
                    } else {
                        membersList(resultMembers, title: Localizable.searchMembersSectionsSearchResults())
                    }
                    
                } else if let oftenMembers = state.oftenMembersViewModels {
                    if oftenMembers.isEmpty {
                        SearchMembersOftenEmptyView { state.didTapInviteByLink() }
                    } else {
                        membersList(oftenMembers, title: Localizable.searchMembersSectionsOften())
                    }
                } else {
                    SearchMembersSkeletonView(title: Localizable.searchGameSectionsOften())
                }
            }
        }
        .animation(.customTransition, value: state.showProgress)
        .animation(.customTransition, value: state.showSkeleton)
        .animation(.customTransition, value: state.selectedMembers)
        .animation(.customTransition, value: state.searchResultMembers)
        .animation(.customTransition, value: state.oftenMembers)
        .activityIndicator(isShown: $state.showProgress)
        .sheet(item: $state.shareInfo, content: { shareInfo in
            ShareActivityView(activityItems: [shareInfo.url])
                //.edgesIgnoringSafeArea(.bottom)
                .presentationDetents([.medium, .large])
        })
        .onAppear {
            state.close = {
                homeCoordinator.closeSheet()
            }
            state.tryFetchOftenDataIfNeeded()
        }
    }
    
    var navigationBar: some View {
        ZStack {
            TitleView(text: Localizable.searchMembersTitle())
            HStack {
                Button(Localizable.commonCancel()) {
                    homeCoordinator.closeSheet()
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 17))
                Spacer()
                Button(Localizable.commonDone()) {
                    state.didTapDoneButton()
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 17))
                .disabled(state.isDoneDisabled)
                .opacity(state.isDoneDisabled ? 0.3 : 1)
            }
        }
        .padding()
    }
    
    var separator: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
            .padding(.leading, 16)
            .frame(height: 1 / UIScreen.main.scale)
    }
    
    var selectedMembersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 2) {
                ForEach(state.selectedMembersViewModels, id:\.model.id) { item in
                    NewEventMemberItemView(model: item)
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            guard !item.isBlocked else { return }
                            Haptic.play(style: .medium)
                            state.didSelectMember(item.model)
                        }
                }
            }
            .frame(maxHeight: 72)
            .padding(.horizontal, 20)
        }
    }
    
    func membersList(_ members: [NewEventMemberCellViewModel], title: String) -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        ForEach(members, id:\.model.id) { member in
                            SearchMemberItemView(viewModel: member)
                                .onTapGesture {
                                    guard !member.isBlocked else { return }
                                    state.didSelectMember(member.model)
                                }
                        }
                    } header: {
                        VStack(spacing: 0) {
                            InviteByLinkButton { state.didTapInviteByLink() }
                                .padding(.top, 16)
                            Text(title)
                                .font(.system(size: 17))
                                .foregroundStyle(Color(.textSecondary))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.top, 20)
                                .padding(.bottom, 12)
                                
                            Rectangle()
                                .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
                                .padding(.leading, 16)
                                .frame(height: 1 / UIScreen.main.scale)
                        }
                        .background {
                            TransparentBlurView(removeAllFilters: false)
                                .blur(radius: 15)
                                .padding([.horizontal, .top], -30)
                                .frame(width: UIScreen.main.bounds.size.width)
                                .ignoresSafeArea()
                        }
                        .background(Color(.background).opacity(0.7))
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
}
