//
//  GeometryGetter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

protocol GeometryGetterDelegate: AnyObject {
    
    func setRect(_ rect: CGRect)
}

struct GeometryGetter: View {
    weak var delegate: GeometryGetterDelegate?
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.delegate?.setRect(geometry.frame(in: .global))
        }

        return Rectangle().fill(Color.clear)
    }
}

   // .background(GeometryGetter(delegate: contextHandler))
