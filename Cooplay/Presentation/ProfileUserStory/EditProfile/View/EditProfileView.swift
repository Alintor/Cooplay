//
//  EditProfileView.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: EditProfileViewModel
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
            VStack(spacing: 0) {
                EditAvatarView(viewModel: viewModel)
                    .padding(.bottom, 24)
                Spacer()
            }
        }
    }
    
}
