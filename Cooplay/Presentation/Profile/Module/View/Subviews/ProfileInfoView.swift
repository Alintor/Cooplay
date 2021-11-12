//
//  ProfileInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileInfoView: View {
    
    let model: User
    
    @State var name: String
    
    init(model: User) {
        self.model = model
        name = model.name
    }
    
    
    var body: some View {
        VStack {
            ProfileAvatar(user: model)
                .frame(width: 108, height: 108, alignment: .center)
            Text(model.name)
                .foregroundColor(Color(R.color.textPrimary.name))
                .font(.system(size: 21, weight: .bold))
                .padding(.top, 16)
                .padding(.bottom, 1)
            if #available(iOS 15.0, *) {
                Text("Alintorius@gmail.com")
                    .foregroundColor(Color(R.color.textSecondary.name))
                    .font(.system(size: 17, weight: .medium))
                    .tint(Color(R.color.textSecondary.name))
            } else {
                Text("Alintorius@gmail.com")
                    .foregroundColor(Color(R.color.textSecondary.name))
                    .font(.system(size: 17, weight: .medium))
            }
        }
    }
}
