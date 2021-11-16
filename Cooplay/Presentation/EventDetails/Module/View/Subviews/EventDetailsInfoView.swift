//
//  EventDetailsInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Kingfisher

struct EventDetailsInfoView: View {
    
    var viewModel: EventInfoViewModel
    
    var body: some View {
        HStack {
            VStack(spacing: 4) {
                Text(viewModel.title)
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color(R.color.textPrimary.name))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(viewModel.date)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(Color(R.color.textSecondary.name))
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
                Image(R.image.commonGameCover.name)
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(8)
                    .padding(.trailing, 24)
            }
        }
    }
    
}
