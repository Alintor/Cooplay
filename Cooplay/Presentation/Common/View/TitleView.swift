//
//  TitleView.swift
//  Cooplay
//
//  Created by Alexandr on 05.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 21, weight: .semibold))
            .foregroundColor(Color(.textPrimary))
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(text: "Test")
    }
}
