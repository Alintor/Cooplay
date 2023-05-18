//
//  EditProfileView.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    
    enum FocusedField {
        case name
    }
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: EditProfileViewModel
    @FocusState private var focusedField: FocusedField?
    var output: EditProfileViewOutput
    
    // MARK: - Init
    
    init(viewModel: EditProfileViewModel, output: EditProfileViewOutput) {
        self.viewModel = viewModel
        self.output = output
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.init(R.color.background()!)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focusedField = nil
                }
            VStack(spacing: 0) {
                EditAvatarView(viewModel: viewModel)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .onTapGesture {
                        output.didTapAvatar()
                        focusedField = nil
                    }
                TextFieldView(
                    text: $viewModel.name,
                    placeholder: Localizable.personalisationNickNameTextFieldPlaceholder()
                )
                    .padding(.horizontal, 24)
                    .focused($focusedField, equals: .name)
                    .onSubmit {
                        if viewModel.isNameValid && viewModel.isNameChanged {
                            output.didTapSave()
                        }
                    }
                HStack {
                    Text(Localizable.editProfileNameDescription())
                        .fontWeight(.medium)
                        .font(.system(size: 12))
                        .foregroundColor(Color(R.color.textSecondary.name))
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                    Spacer()
                }
                Spacer()
                MainActionButton(Localizable.editProfileSaveButton(), isDisabled: viewModel.isButtonDisabled) {
                    focusedField = nil
                    output.didTapSave()
                }
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.bottom, 16)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .animation(.default, value: viewModel.name)
        .animation(.default, value: focusedField)
        .onAppear {
            focusedField = nil
        }
    }
    
}
