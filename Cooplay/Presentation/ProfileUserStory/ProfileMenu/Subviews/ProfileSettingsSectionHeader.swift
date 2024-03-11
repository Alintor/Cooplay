//
//  ProfileSettingsSectionHeader.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileSettingsSectionHeader: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .foregroundColor(Color(R.color.textSecondary.name))
                .font(.system(size: 13))
            Spacer()
        }
        .padding(EdgeInsets(top: 24, leading: 24, bottom: 8, trailing: 16))
    }
}
