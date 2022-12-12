//
//  EventDetailsNotificationView.swift
//  EventStatusNotification
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Kingfisher

struct EventDetailsNotificationView: View {
    
    @ObservedObject var viewModel: EventDetailsNotificationViewModel
    
    var body: some View {
        HStack {
            VStack(spacing: 4) {
                Text(viewModel.title)
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color("text.primary"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.date)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(Color("text.secondary"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 24)
            Spacer(minLength: 8)
            if let path = viewModel.coverPath {
                KFImage(URL(string: path))
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(8)
                    .padding(.trailing, 24)
            } else {
                Image("common.gameCover")
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(8)
                    .padding(.trailing, 24)
            }
        }
    }
    
}
