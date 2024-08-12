//
//  SearchGameView.swift
//  Cooplay
//
//  Created by Alexandr on 10.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchGameView: View {
    
    @StateObject var state: SearchGameState
    @EnvironmentObject var homeCoordinator: HomeCoordinator
    @State var searchInput = ""
    
    var body: some View {
        ZStack {
            Color(.background)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                VStack {
                    navigationBar
                    SearchField(text: $searchInput, placeholder: Localizable.searchGameSearchBarPlaceholder())
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                        .disabled(state.showProgress)
                        .onChange(of: searchInput) { newValue in
                            if newValue.isEmpty {
                                state.searchResultGames = nil
                            }
                        }
                        .onSubmit {
                            state.searchGame(name: searchInput)
                        }
                }
                .background(Color(.block))
                if state.showProgress {
                    SearchGameSkeletonView(title: Localizable.searchGameSectionsSearchResults())
                        .transition(.opacity)
                } else if let resultGames = state.searchResultGames {
                    if resultGames.isEmpty {
                        SearchGameEmptyResultView()
                    } else {
                        gamesList(resultGames, title: Localizable.searchGameSectionsSearchResults())
                    }
                    
                } else if let oftenGames = state.oftenGames {
                    if oftenGames.isEmpty {
                        SearchGameOftenEmptyView()
                    } else {
                        gamesList(oftenGames, title: Localizable.searchGameSectionsOften())
                    }
                } else {
                    SearchGameSkeletonView(title: Localizable.searchGameSectionsOften())
                }
            }
        }
        .animation(.customTransition, value: state.showProgress)
        .animation(.customTransition, value: state.oftenGames)
        .animation(.customTransition, value: state.searchResultGames)
        .onAppear {
            state.close = {
                homeCoordinator.closeSheet()
            }
            state.tryFetchOftenDataIfNeeded()
        }
    }
    
    var navigationBar: some View {
        ZStack {
            TitleView(text: Localizable.searchGameTitle())
            HStack {
                Button(Localizable.commonCancel()) {
                    homeCoordinator.closeSheet()
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 17))
                Spacer()
            }
        }
        .padding()
    }
    
    func gamesList(_ games: [NewEventGameViewModel], title: String) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(games, id:\.model.slug) { game in
                        SearchGameItemView(viewModel: game)
                            .onTapGesture {
                                state.didSelectGame(game.model)
                            }
                    }
                } header: {
                    VStack(spacing: 0) {
                        Text(title)
                            .font(.system(size: 17))
                            .foregroundStyle(Color(.textSecondary))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 12)
                            .background {
                                TransparentBlurView(removeAllFilters: false)
                                    .blur(radius: 15)
                                    .padding([.horizontal, .top], -30)
                                    .frame(width: UIScreen.main.bounds.size.width)
                                    .ignoresSafeArea()
                            }
                        Rectangle()
                            .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
                            .padding(.leading, 16)
                            .frame(height: 1 / UIScreen.main.scale)
                    }
                    .background(Color(.background).opacity(0.7))
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
}
