//
//  ProfileView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 21.10.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    let model: User
    let output: ProfileViewOutput?
    
    var body: some View {
        ZStack {
            Color.init(R.color.background()!)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 0) {
                    ProfileInfoView(model: model)
                        .padding(.bottom, 16)
                    
                    ProfileSettingsCell(
                        title: "Редактировать профиль",
                        iconName: R.image.commonPlus.name,
                        iconBgColor: Color(R.color.actionAccent.name)
                    )
                    
                    ProfileSettingsSectionHeader(title: "Настройки")
                    
                    ProfileSettingsCell(
                        title: "Уведомления",
                        iconName: R.image.commonArrowUp.name,
                        iconBgColor: Color(R.color.yellow.name)
                    )
                    ProfileSettingsSeparator().frame(height: 0.5)
                    
                    ProfileSettingsCell(
                        title: "Сменить пароль",
                        iconName: R.image.commonArrowDown.name,
                        iconBgColor: Color(R.color.green.name)
                    )
                    
                    ProfileSettingsSectionHeader(title: "Управление аккаунтом")
                    
                    ProfileSettingsCell(
                        title: "Аккаунт",
                        iconName: R.image.commonEdit.name,
                        iconBgColor: Color(R.color.grey.name)
                    )
                    ProfileSettingsSeparator().frame(height: 0.5)
                    
                    ProfileSettingsCell(
                        title: "Выйти",
                        iconName: R.image.commonNormalCrown.name,
                        iconBgColor: Color(R.color.red.name)
                    )
                }
                .padding(.top, 48)
            }
        }
    }
}

struct ProfileAvatar: View {
    
    let viewModel: AvatarViewModel
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color(viewModel.backgroundColor))
            Text(viewModel.firstNameLetter)
                .fontWeight(.semibold)
                .font(.system(size: 48))
        }
    }
}

struct ProfileInfoView: View {
    
    let model: User
    
    @State var name: String
    
    init(model: User) {
        self.model = model
        name = model.name
    }
    
    
    var body: some View {
        VStack {
            ProfileAvatar(viewModel: AvatarViewModel(with: model))
                .frame(width: 108, height: 108, alignment: .center)
            TextField("Name", text: $name)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(R.color.textPrimary()!))
                .font(.system(size: 28, weight: .semibold, design: .default))
            Text("Alintorius@gmail.com")
                .foregroundColor(Color.init(R.color.textSecondary()!))
                .font(.system(size: 17))
                .padding(EdgeInsets(top: -8, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct ProfileSettingsCell: View {
    
    let title: String
    let iconName: String
    let iconBgColor: Color
    
    var body: some View {
        HStack {
            ZStack {
                Circle().foregroundColor(iconBgColor)
                Image(iconName)
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(15, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }.frame(width: 30, height: 30, alignment: .center)
            Text(title).foregroundColor(Color(R.color.textPrimary()!)).fontWeight(.bold)
            Spacer()
        }.padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
    }
}

struct ProfileSettingsSeparator: View {
    var body: some View {
        Rectangle().foregroundColor(Color(UIColor.white.withAlphaComponent(0.35))).padding(EdgeInsets(top: 0, leading: 62, bottom: 0, trailing: 24))
            .frame(height: 1)
    }
}

struct ProfileSettingsSectionHeader: View {
    
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .foregroundColor(Color(R.color.textSecondary()!))
                .font(.system(size: 13))
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 16))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(model: User(id: "dsfdhfgdfgfs", name: "Alintor", avatarPath: nil, state: nil, lateness: nil, isOwner: nil), output: nil)
    }
}
