//
//  RectHandler.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct RectHandlerGetter: View {
    var action: ((_ rect: CGRect) -> Void)?
    var coordinateSpace: CoordinateSpace
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.action?(geometry.frame(in: coordinateSpace))
        }

        return Rectangle().fill(Color.clear)
    }
}

extension View {
    
    func handleRect(in coordinateSpace: CoordinateSpace, handler: ((_ rect: CGRect) -> Void)?) -> some View {
        self.background(RectHandlerGetter(action: handler, coordinateSpace: coordinateSpace))
    }
}
