//
//  OnboardingCardView.swift
//  Cooplay
//
//  Created by Alexandr on 01.08.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Combine
import CoreHaptics

struct OnboardingCardView: View {
    
    @ObservedObject var manager = MotionManager()
    @State private var engine: CHHapticEngine?
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    @State var frontSide: OnboardingCardSide = .accepted
    @State var backSide: OnboardingCardSide = .decline
    @State var showFrontBigAvatar = false
    @State var showFrontBubble = false
    @State var showFrontMiddleAvatar = false
    @State var showFrontSmallAvatar = false
    @State var showFrontReaction = false
    @State var showBackBigAvatar = true
    @State var showBackBubble = true
    @State var showBackMiddleAvatar = true
    @State var showBackSmallAvatar = true
    @State var showBackReaction = true
    @State var canDrag = true
    @State var prevBackValueDegree = 0.0
    @State var timer = Timer.publish(every: 4, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    @State var isFlipped = true
    @State var isFlipping = false {
        didSet {
            withAnimation(.bounceLittleTransition) {
                showFrontBigAvatar = !isFlipped && !isFlipping
                showBackBigAvatar = isFlipped && !isFlipping
            }
            withAnimation(.bounceLittleTransition.delay(isFlipping ? 0 : 0.1)) {
                showFrontBubble = !isFlipped && !isFlipping
                showBackBubble = isFlipped && !isFlipping
            }
            withAnimation(.bounceLittleTransition.delay(isFlipping ? 0 : 0.2)) {
                showFrontSmallAvatar = !isFlipped && !isFlipping
                showBackSmallAvatar = isFlipped && !isFlipping
            }
            withAnimation(.bounceLittleTransition.delay(isFlipping ? 0 : 0.25)) {
                showFrontMiddleAvatar = !isFlipped && !isFlipping
                showBackMiddleAvatar = isFlipped && !isFlipping
            }
            withAnimation(.bounceLittleTransition.delay(isFlipping ? 0 : 0.4)) {
                showFrontReaction = !isFlipped && !isFlipping
                showBackReaction = isFlipped && !isFlipping
            }
            if !isFlipping {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if !isFlipping { playTaptic(intensity: 0.3, sharpness: 0.3) }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    if !isFlipping { playTaptic(intensity: 0.5, sharpness: 0.5) }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if !isFlipping { playTaptic(intensity: 0.7, sharpness: 0.7) }
                }
            }
        }
    }
    let durationAndDelay : CGFloat = 0.2
    
    // MARK: - Methods
    
    func instantiateTimer() {
        self.timer = Timer.publish(every: 4, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
    }
        
    func cancelTimer() {
        self.connectedTimer?.cancel()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func playTaptic(intensity: Float = 0.3, sharpness: Float = 0) {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func flipCard () {
        cancelTimer()
        instantiateTimer()
        withAnimation(.customTransition) {
            isFlipping = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + durationAndDelay) {
            withAnimation(.customTransition) {
                isFlipping = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + durationAndDelay * 2) {
            Haptic.play(style: .soft)
        }
        if isFlipped {
            backDegree = 180
            frontDegree = 90
            frontSide = backSide.next
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
                prevBackValueDegree = 90
            }
            withAnimation(.bounceLittleTransition.delay(durationAndDelay)){
                frontDegree = 0
                isFlipped = !isFlipped
            }
        } else {
            frontDegree = 0
            backDegree = -90
            backSide = frontSide.next
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.bounceLittleTransition.delay(durationAndDelay)){
                backDegree = -180
                prevBackValueDegree = -180
                isFlipped = !isFlipped
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            backSideView
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(Angle(degrees: backDegree), axis: (x: 0, y: 1, z: 0))
            frontSideView
                .rotation3DEffect(Angle(degrees: frontDegree), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture {
            flipCard ()
        }
        .highPriorityGesture(DragGesture()
            .onChanged { state in
                guard canDrag else { return }
                
                cancelTimer()
                playTaptic()
                if !isFlipping {
                    withAnimation(.customTransition) {
                        isFlipping = true
                    }
                }
                let newDegree = state.translation.width * 0.8
                if !isFlipped {
                    if abs(newDegree) >= 90 {
                        frontDegree = copysign(90, newDegree)
                        if abs(newDegree) >= 180 {
                            backDegree = copysign(180, newDegree)
                            prevBackValueDegree = backDegree
                            isFlipped = true
                            canDrag = false
                            Haptic.play(style: .soft)
                        } else {
                            backDegree = newDegree
                        }
                    } else {
                        let newBackSide = newDegree < 0 ? frontSide.next : frontSide.prev
                        if backSide != newBackSide {
                            backSide = newBackSide
                            print(backSide.statusTitle)
                        }
                        frontDegree = newDegree
                        backDegree = -90
                    }
                } else {
                    let newFlipDegree = state.translation.width * 0.8 + prevBackValueDegree
                    if abs(newDegree) >= 90 {
                        backDegree =  copysign(90, newFlipDegree)
                        if abs(newDegree) >= 180 {
                            frontDegree = copysign(0, newFlipDegree)
                            prevBackValueDegree = backDegree
                            isFlipped = false
                            canDrag = false
                            Haptic.play(style: .soft)
                        } else {
                            frontDegree = newFlipDegree
                        }
                    } else {
                        let newFrontSide = newDegree < 0 ? backSide.next : backSide.prev
                        if frontSide != newFrontSide {
                            frontSide = newFrontSide
                            print(frontSide.statusTitle)
                        }
                        backDegree = newFlipDegree
                        frontDegree = 90
                    }
                }
            }
            .onEnded({ state in
                instantiateTimer()
                guard canDrag else {
                    canDrag = true
                    withAnimation(.customTransition) {
                        isFlipping = false
                    }
                    return
                }
                
                let endDegree = state.translation.width * 0.8
                canDrag = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    Haptic.play(style: .medium)
                }
                withAnimation(.bounceLittleTransition) {
                    if endDegree < 90 && endDegree > -90 {
                        if !isFlipped {
                            frontDegree = 0
                            backDegree = -90
                        } else {
                            frontDegree = 90
                            backDegree = 180
                        }
                    } else {
                        if !isFlipped {
                            frontDegree = copysign(90, frontDegree)
                            backDegree = copysign(180, backDegree)
                        } else {
                            if frontDegree > 0 && frontDegree < 180 {
                                frontDegree = 0
                            } else if frontDegree < 0 && frontDegree > -180 {
                                frontDegree = 0
                            } else {
                                frontDegree = copysign(360, frontDegree)
                            }
                            backDegree = copysign(90, backDegree)
                        }
                        isFlipped.toggle()
                    }
                    isFlipping = false
                    prevBackValueDegree = backDegree
                }
            })
        )
        .onAppear {
            prepareHaptics()
            flipCard()
        }
        .onDisappear {
            cancelTimer()
        }
        .onReceive(timer) { _ in
            flipCard()
        }
    }
    
    // MARK: - Subviews
    
    var frontSideView: some View {
        ZStack {
            gameCard(
                cover: frontSide.gameCover,
                title: frontSide.gameTitle,
                date: frontSide.gameDate
            )
            sideItems(isFront: true, side: frontSide)
        }
        .frame(width: 220, height: 300)
    }
    
    var backSideView: some View {
        ZStack {
            gameCard(
                cover: backSide.gameCover,
                title: backSide.gameTitle,
                date: backSide.gameDate
            )
            sideItems(isFront: false, side: backSide)
        }
        .frame(width: 220, height: 300)
    }
    
    func gameCard(cover: Image, title: String, date: String) -> some View {
        VStack(spacing: 0) {
            cover
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 180)
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 40)
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Color(.textPrimary))
                .padding(.horizontal, 16)
                .padding(.top, 12)
            Text(date)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color(.textSecondary))
                .padding(.horizontal, 16)
                .padding(.top, 2)
        }
        .padding(.vertical, 24)
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 40, style: .continuous))
        .modifier(ParallaxMotionModifier(manager: manager))
    }
    
    func bubbleView(title: String, color: Color) -> some View {
        HStack(spacing: 0) {
            Circle().fill(color)
                .frame(width: 8, height: 8)
                .padding(.bottom, -4)
            Circle().fill(color)
                .frame(width: 18, height: 18)
                .padding(.top, -16)
            Text(title)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(Color(.background))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(color)
                .clipShape(.rect(cornerRadius: 40, style: .continuous))
                .padding(.top, -50)
                .padding(.leading, -22)
        }
    }
    
    func sideItems(isFront: Bool, side: OnboardingCardSide) -> some View {
        VStack {
            HStack(spacing: 0) {
                if isFront ? showFrontBigAvatar : showBackBigAvatar {
                    side.bigAvatar
                        .padding(.leading, -16)
                        .padding(.top, 16)
                        .transition(.scale.combined(with: .opacity))
                        //.modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                }
                if isFront ? showFrontBubble : showBackBubble {
                    bubbleView(
                        title: side.statusTitle,
                        color: side.color
                    )
                    .padding(.top, -8)
                    .padding(.leading, -5)
                    .transition(.scale.combined(with: .opacity))
                    //.modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                }
                Spacer()
                if isFront ? showFrontReaction : showBackReaction {
                    Text(side.reaction)
                        .font(.system(size: 20))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.shapeBackground))
                        .clipShape(.rect(cornerRadius: 50, style: .continuous))
                        .padding(.top, -24)
                        .padding(.trailing, -16)
                        .transition(.scale.combined(with: .opacity))
                        //.modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                }
            }
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                if isFront ? showFrontSmallAvatar : showBackSmallAvatar {
                    side.smallAvatar
                    .padding(.bottom, -28)
                    .padding(.trailing, -16)
                    .zIndex(2)
                    .transition(.scale.combined(with: .opacity))
                    //.modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                }
                if isFront ? showFrontMiddleAvatar : showBackMiddleAvatar {
                    side.middleAvatar
                        .padding(.bottom, -4)
                        .padding(.trailing, -18)
                        .transition(.scale.combined(with: .opacity))
                        //.modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                }
            }
        }
    }
    
}
