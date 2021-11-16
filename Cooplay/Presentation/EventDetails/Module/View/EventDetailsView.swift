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
    
    let contextMenuHandler = ContextMenuHandler(viewCornerType: .rounded(value: 12))
    
    @State var statusViewTapped: Bool = false
    @State var isStatusViewHidden: Bool = false
    
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
        ZStack {
            Color(R.color.background.name)
                .edgesIgnoringSafeArea(.all)
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
                            .animation(.easeInOut, value: viewModel.modeState.isEditMode)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    ForEach(viewModel.members, id:\.name) { item in
                        EventDetailsMemberView(viewModel: item, output: output)
                            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.top, 16)
            }
            .padding(.top, 1)
            .padding(.bottom, 66)
            VStack {
                Spacer()
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
                            let contextView = StatusContextView(contextType: .overTarget, delegate: contextMenuHandler)
                            contextView.showMenu(size: .large, type: .statuses(type: .agreement, event: viewModel.event, actionHandler: nil))
                        }
                    }
            }
        }
        .onAppear {
            configureHandler()
        }
        .onReceive(viewModel.$modeState) { value in
            withAnimation {
                isEditMode = value.isEditMode
            }
        }
        
    }
}







//struct EventDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventDetailsView()
//    }
//}
