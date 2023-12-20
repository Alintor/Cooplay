//
//  EditProfileView.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    
    enum FocusedField {
        case name
    }
    
    // MARK: - Properties
    
    @EnvironmentObject var state: EditProfileState
    @EnvironmentObject var namespace: NamespaceWrapper
    @FocusState private var focusedField: FocusedField?
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
            editView
            if state.showAvatarSheet {
                EditSheetView(
                    showAlert: $state.showAvatarSheet,
                    canDelete: state.canDeleteAvatar,
                    cameraAction: {
                        state.showAvatarSheet = false
                        state.checkPermissions()
                    },
                    photoAction: {
                        state.photoPickerTypeCamera = false
                        state.showPhotoPicker = true
                    },
                    deleteAction: { state.removeAvatar() })
            }
        }
        .animation(.default, value: state.name)
        .animation(.default, value: focusedField)
        .onAppear {
            focusedField = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                state.needShowProfileAvatar?.wrappedValue = false
            }
        }
        .onDisappear {
            state.needShowProfileAvatar?.wrappedValue = true
        }
        .sheet(isPresented: $state.showPhotoPicker) {
            EditPhotoPickerView(
                showAlert: $state.showPhotoPicker,
                fromCamera: state.photoPickerTypeCamera) { image in
                    state.addImage(image)
                }
                .edgesIgnoringSafeArea(.bottom)
        }
        .alert(Localizable.editProfilePermissionsAlertTitle(), isPresented: $state.showPermissionsAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.editProfilePermissionsAlertSetting()) {
                state.openSettings()
            }
        })
    }
    
    // MARK: - Subviews
    
    var editView: some View {
        VStack(spacing: 0) {
            EditAvatarView()
                .padding(.top, 24)
                .padding(.bottom, 32)
                .onTapGesture {
                    state.showAvatarSheet = true
                    focusedField = nil
                }
            TextFieldView(
                text: $state.name,
                placeholder: Localizable.editProfileNicknamePlaceholder()
            )
                .padding(.horizontal, 24)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    if state.isNameValid && state.isNameChanged {
                        state.saveChange()
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
            MainActionButton(Localizable.editProfileSaveButton(), isDisabled: state.isButtonDisabled) {
                focusedField = nil
                state.saveChange()
            }
            .padding(.leading, 24)
            .padding(.trailing, 24)
            .padding(.bottom, 16)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
}
