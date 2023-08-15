//
//  NotificationSettingsView.swift
//  Cooplay
//
//  Created by Alexandr on 01/08/2023.
//

import SwiftUI

struct NotificationSettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: NotificationSettingsViewModel
    var output: NotificationSettingsViewOutput
    
    // MARK: - Init
    
    init(viewModel: NotificationSettingsViewModel, output: NotificationSettingsViewOutput) {
        self.viewModel = viewModel
        self.output = output
    }
    
    // MARK: - Body
    
    var body: some View {
        Text("")
    }
    
}