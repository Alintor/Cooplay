//
//  ProfileSettingsSeparator.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileSettingsSeparator: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color(UIColor.white.withAlphaComponent(0.1)))
            .padding(EdgeInsets(top: 0, leading: 68, bottom: 0, trailing: 24))
            .frame(height: 1 / UIScreen.main.scale)
    }
}
