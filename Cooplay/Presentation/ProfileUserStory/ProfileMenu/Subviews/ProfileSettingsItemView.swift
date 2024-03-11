//
//  ProfileSettingsItemView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileSettingsItemView: View {
    
    let item: ProfileSettingsItem
    
    var body: some View {
        HStack {
            ZStack {
                Circle().foregroundColor(item.iconColor)
                item.iconImage
                    .frame(width: 20, height: 20, alignment: .center)
                    .cornerRadius(15, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30, alignment: .center)
            .padding(.trailing, 6)
            Text(item.title)
                .foregroundColor(Color(R.color.textPrimary.name))
                .font(.system(size: 17, weight: .semibold))
            Spacer()
            item.actionImage
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(Color(R.color.textSecondary.name))
        }
        .contentShape(Rectangle())
        .padding(EdgeInsets(top: 9, leading: 24, bottom: 9, trailing: 24))
    }
}
