//
//  ProfileView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 21.10.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var state: ProfileState
    let output: ProfileViewOutput?
    
    var body: some View {
        ZStack {
            Color.init(R.color.background()!)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 0) {
                    ProfileInfoView(model: state.profile)
                        .padding(.bottom, 24)
                    
                    ForEach(ProfileSettingsItem.Section.allCases) { sectionItem in
                        if !sectionItem.title.isEmpty {
                            ProfileSettingsSectionHeader(title: sectionItem.title)
                        }
                        if let items = state.settings[sectionItem] {
                            ForEach(items, id:\.self) { item in
                                ProfileSettingsItemView(item: item)
                                    .onTapGesture { output?.itemSelected(item) }
                                if item != items.last {
                                    ProfileSettingsSeparator()
                                }
                            }
                        }
                    }
                }
                .padding(.top, 48)
            }
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(model: User(id: "dsfdhfgdfgfs", name: "Alintor", avatarPath: nil, state: nil, lateness: nil, isOwner: nil), output: nil)
//    }
//}
