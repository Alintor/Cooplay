//
//  EventDetailsView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsView: View {
    
    @ObservedObject var viewModel: EventDetailsViewModel
    var output: EventDetailsViewOutput
    
    init(viewModel: EventDetailsViewModel, output: EventDetailsViewOutput) {
        self.viewModel = viewModel
        self.output = output
        members = viewModel.members
        reactions = viewModel.reactions
    }
    
    let contextMenuHandler = ContextMenuHandler(viewCornerType: .rounded(value: 12))
    
    @State var statusViewTapped: Bool = false
    @State var isStatusViewHidden: Bool = false
    
    @State var members: [EventDetailsMemberViewModel]
    @State var reactions: [ReactionViewModel]
    
    @State var isEditMode = false
    
    func configureHandler() {
        contextMenuHandler.completion = { item in
            self.statusViewTapped.toggle()
            guard let event = item?.value as? Event else { return }
            viewModel.update(with: event)
        }
        contextMenuHandler.hideTargetView = { hide in
            self.isStatusViewHidden = hide
        }
    }
    
    var body: some View {
        configureHandler()
        return ZStack {
            Color(R.color.background.name)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        if isEditMode {
                            EventDetailsEditInfoView(viewModel: viewModel.infoViewModel, output: output)
                                .padding(EdgeInsets(top: 0, leading: 24, bottom: 24, trailing: 24))
                                .transition(.scale.combined(with: .opacity))
                            EventDetailsAddMemberView()
                                .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                                .transition(.scale.combined(with: .opacity))
                                .onTapGesture {
                                    output.addMemberAction()
                                }
                        } else {
                            EventDetailsInfoView(viewModel: viewModel.infoViewModel)
                                .padding(.bottom, 24)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        ForEach(members, id:\.name) { item in
                            EventDetailsMemberView(viewModel: item, output: output)
                                .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                                .animation(.easeInOut(duration: 0.2))
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 48)
                }
                .padding(.top, 1)
                .padding(.bottom, -48)
                ZStack {
                    ReactionsListOwnerView(reactions: reactions, output: output, reactionContextViewHandler: nil, member: viewModel.event.me)
                        .animation(.easeInOut(duration: 0.2))
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color(R.color.background.name), Color(R.color.background.name).opacity(0)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: 10, height: 48, alignment: .center)
                        Spacer()
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color(R.color.background.name).opacity(0), Color(R.color.background.name)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: 10, height: 48, alignment: .center)
                    }
                }
                EventStatusView(viewModel: viewModel.statusViewModel, isTapped: $statusViewTapped, contextMenuHandler: contextMenuHandler)
                    .background(Color(R.color.block.name))
                    .cornerRadius(12)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    .animation(.easeInOut(duration: EventStatusView.animationDuration), value: statusViewTapped)
                    .opacity(isStatusViewHidden ? 0 : 1)
                    .onTapGesture {
                        statusViewTapped.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + EventStatusView.animationDuration + 0.1) {
                            contextMenuHandler.takeSnaphot()
                            output.statusAction(with: contextMenuHandler)
                        }
                    }
            }
            VStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(R.color.background.name), Color(R.color.background.name).opacity(0)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(height: 20, alignment: .center)
                Spacer()
            }
        }
        .onReceive(viewModel.$modeState) { value in
            withAnimation {
                isEditMode = value.isEditMode
            }
        }
        .onReceive(viewModel.$members) { members in
            withAnimation {
                self.members = members
            }
        }
        .onReceive(viewModel.$reactions) { reactions in
            withAnimation {
                self.reactions = reactions
            }
        }
        
    }
}







//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
