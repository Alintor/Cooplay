//
//  LogoSpinnerView.swift
//  Cooplay
//
//  Created by Alexandr on 26.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct LogoSpinnerView: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: HomeCoordinator
    @State var location = CGPoint.zero
    @GestureState private var isTapped = false
    @State var initialLocation = CGPoint.zero
    @State var showHint = true
    @State var rotateDegrees: Double = 0
    @State var prevPosition = CGPoint.zero
    @State var isInZone = false
    @State var isLogoDisabled = true
    @State private var timer: Timer?
    @State private var lastVelocity: CGFloat = 0
    @State private var lastAngle: CGFloat = 0
    var logoSideSize: CGFloat {
        if isTapped && isInZone {
            return 48
        } else if isTapped {
            return 150
        } else {
            return 128
        }
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { state in
                        timer?.invalidate()
                        if prevPosition == .zero {
                            prevPosition = state.startLocation
                        }
                        let angle = round(calculateDirection(prevPosition: prevPosition, currentPosition: state.location)) * 0.4
                        rotateDegrees += angle
                        prevPosition = state.location
                        handleHaptic(newAngle: angle)
                    }
                    .onEnded { state in
                        let velocity = calculateDirection(prevPosition: prevPosition, currentPosition: state.predictedEndLocation)
                        prevPosition = .zero
                        lastVelocity = velocity * 0.02
                        timer?.invalidate()
                        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                            rotateDegrees += lastVelocity
                            handleHaptic(newAngle: lastVelocity)
                            if abs(lastVelocity) > 0.5 {
                                lastVelocity *= (1 - 0.005)
                            } else {
                                lastVelocity = copysign(0.5, lastVelocity)
                            }
                            if abs(lastVelocity) <= 1 && round(abs(rotateDegrees)).truncatingRemainder(dividingBy: 360) == 0 {
                                timer.invalidate()
                            }
                        }
                    }
                )
            VStack {
                HStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color(.block))
                        .onTapGesture { didTapCloseZone() }
                        .disabled(showHint)
                    HStack(spacing: 0) {
                        Image(.commonBack)
                            .foregroundStyle(Color(.textSecondary))
                            .frame(width: 32, height: 32)
                        Text(Localizable.logoSpinnerHint())
                            .foregroundStyle(Color(.textSecondary))
                            .font(.system(size: 13))
                    }
                    .opacity(showHint ? 1 : 0)
                    .scaleEffect(showHint ? 1 : 0, anchor: .leading)
                }
                Spacer()
            }
            Image(R.image.commonLogoIcon.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color(.actionAccent))
                .frame(width: logoSideSize, height: logoSideSize)
                .clipped()
                .contentShape(Rectangle())
                .rotationEffect(.degrees(rotateDegrees), anchor: .center)
                .position(location)
                .matchedGeometryEffect(id: MatchedAnimations.logo.name, in: namespace.id)
                .animation(.bounceTransition, value: location)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged { state in
                        isInZone = state.location.x < 80 && state.location.y < 80
                        location = state.location
                    }
                    .onEnded{ state in
                        if state.location.x < 80 && state.location.y < 80 {
                            Haptic.play(style: .medium)
                            timer?.invalidate()
                            coordinator.showLogoSpinner = false
                        } else {
                            location = initialLocation
                        }
                    }
                    .updating($isTapped, body: { _, isTapped, _ in
                        isTapped = true
                    })
                )
                .disabled(isLogoDisabled)
        }
        .animation(.bounceTransition, value: isTapped)
        .animation(.snappy(duration: 0.3), value: showHint)
        .animation(.bounceTransition, value: rotateDegrees)
        .handleRect(in: .global) { rect in
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            initialLocation = center
            if location == .zero {
                location = center
            }
        }
        .onChange(of: isTapped) { newValue in
            if newValue {
                Haptic.play(style: .medium)
            }
        }
        .onChange(of: isInZone) { _ in
            Haptic.play(style: .soft)
        }
        .onAppear {
            didTapCloseZone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isLogoDisabled = false
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func handleHaptic(newAngle: CGFloat) {
        if abs(lastAngle + newAngle) > 30 {
            Haptic.play(style: .soft)
            lastAngle = 0
        } else {
            lastAngle += newAngle
        }
    }
    
    func didTapCloseZone() {
        Haptic.play(style: .soft)
        showHint = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showHint = false
        }
    }
    
    func calculateDirection(prevPosition: CGPoint, currentPosition: CGPoint) -> CGFloat {
        let diffY = currentPosition.y - prevPosition.y
        let diffX = currentPosition.x - prevPosition.x
        if prevPosition.y < location.y && prevPosition.x < location.x {
            return abs(diffY) > abs(diffX) ? -diffY : diffX
        }
        if prevPosition.y < location.y && prevPosition.x > location.x {
            return abs(diffY) > abs(diffX) ? diffY : diffX
        }
        if prevPosition.y > location.y && prevPosition.x < location.x {
            return abs(diffY) > abs(diffX) ? -diffY : -diffX
        }
        if prevPosition.y > location.y && prevPosition.x > location.x {
            return abs(diffY) > abs(diffX) ? diffY : -diffX
        }
        return 0
    }
    
}
