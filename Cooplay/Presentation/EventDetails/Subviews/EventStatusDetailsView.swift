//
//  EventStatusDetailsView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventStatusDetailsView: View {
    
    let viewModel: StatusDetailsViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color(R.color.textPrimary.name))
            Text(viewModel.subtitle)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(R.color.textSecondary.name))
        }
    }
}

