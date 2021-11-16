//
//  EventDetailsEditInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsEditInfoView: View {
    
    var viewModel: EventInfoViewModel
    weak var output: EventDetailsViewOutput?
    private let contextHandler = ContextMenuHandler(viewCornerType: .rounded(value: 12))
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(viewModel.title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(R.color.actionAccent.name))
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
                Spacer()
                Image(R.image.commonArrowDown.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color(R.color.textSecondary.name))
                    .padding(.trailing, 16)
            }
            .background(Rectangle().foregroundColor(Color(R.color.block.name)))
            .cornerRadius(12)
            .onTapGesture {
                output?.changeGameAction()
            }
            
            HStack {
                Text(viewModel.date)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(R.color.actionAccent.name))
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
                Spacer()
                Image(R.image.commonArrowDown.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color(R.color.textSecondary.name))
                    .padding(.trailing, 16)
            }
            .background(Rectangle().foregroundColor(Color(R.color.block.name)))
            .cornerRadius(12)
            .background(GeometryGetter(delegate: contextHandler))
            .onTapGesture {
                contextHandler.takeSnaphot()
                output?.changeDateAction(delegate: contextHandler)
            }
        }
    }
}

