//
//  ParallaxModifier.swift
//  Cooplay
//
//  Created by Alexandr on 01.08.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import CoreMotion

struct ParallaxMotionModifier: ViewModifier {
    
    @ObservedObject var manager: MotionManager
    let magnitude: Double = 0.2
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(Angle(radians: manager.roll * magnitude), axis: (x: 0, y: -1, z: 0))
            .rotation3DEffect(Angle(radians: manager.pitch * magnitude * 0.5), axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(Angle(radians: manager.yaw * magnitude * 0.3), axis: (x: 0, y: 0, z: 1))
    }
}

class MotionManager: ObservableObject {

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var yaw: Double = 0.0
    
    private var manager: CMMotionManager

    init() {
        self.manager = CMMotionManager()
        self.manager.deviceMotionUpdateInterval = 1/30
        self.manager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            let maxValue: Double = 0.5
            if let motionData = motionData {
                self.pitch = abs(motionData.attitude.pitch) > maxValue ? copysign(maxValue, motionData.attitude.pitch) : motionData.attitude.pitch
                self.roll = abs(motionData.attitude.roll) > maxValue ? copysign(maxValue, motionData.attitude.roll) : motionData.attitude.roll
                self.yaw = abs(motionData.attitude.yaw) > maxValue ? copysign(maxValue, motionData.attitude.yaw) : motionData.attitude.yaw
            }
        }

    }
}
