//
//  ContextView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.02.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Moya

struct ContextView: View {
    
    var image: UIImage
    var rect: CGRect
    @Binding var visible: Bool
    @Binding var targetHidden: Bool
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark))
                .edgesIgnoringSafeArea(.all)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Image(uiImage: image)
                .resizable()
                .frame(width: rect.size.width, height: rect.size.height)
                .edgesIgnoringSafeArea(.all)
                .cornerRadius(12)
                .position(x: rect.origin.x + (rect.size.width / 2), y: rect.origin.y + (rect.size.height / 2) - UIApplication.shared.statusBarFrame.height)
                .onTapGesture {
                    targetHidden.toggle()
                    visible.toggle()
                    topViewController()?.dismiss(animated: false) {
                        //visible.toggle()
                    }
                }
        }
        .onAppear {
            targetHidden.toggle()
        }
    }
    
    private func topViewController(baseVC: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
            
            if let nav = baseVC as? UINavigationController {
                return topViewController(baseVC: nav.visibleViewController)
            }
            if let tab = baseVC as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(baseVC: selected)
                }
            }
            if let presented = baseVC?.presentedViewController {
                return topViewController(baseVC: presented)
            }
            return baseVC
        }
}


struct TargetView: View {
    
    @Binding var visible: Bool
    @Binding var targetHidden: Bool
    
    @State private var rect = CGRect.zero
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
        .showContext(with: rect, isPresented: $visible, targetHidden: $targetHidden)
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            let viewFrame = geometry.frame(in: .global)
            if viewFrame.origin.x > 0 || viewFrame.origin.y > 0 {
                self.rect = viewFrame
            }
        }

        return Rectangle().fill(Color.clear)
    }
}

struct GeometryGetter2: View {
    var action: ((_ rect: CGRect) -> Void)?
    var coordinateSpaceName: String
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.action?(geometry.frame(in: .named(coordinateSpaceName)))
        }

        return Rectangle().fill(Color.clear)
    }
}

extension GeometryReader {
    
//    public func showContext(isPresented: Binding<Bool>) -> some View {
//        var rect = CGRect.zero
//        self.showContext(with: rect, isPresented: isPresented)
//        return self.background(GeometryGetter2(action: { viewFrame in
//            rect = viewFrame
//        }))
//    }
    
    func showContext(with rect: CGRect, isPresented: Binding<Bool>, targetHidden: Binding<Bool>) -> some View {
//        let image = topWindow?.asImage(rect: CGRect(origin: rect.origin, size: rect.size))
//
//        let hostingVC = UIHostingController(rootView: ContextView(image: image!, rect: rect, visible: isPresented))
//        hostingVC.modalPresentationStyle = .overCurrentContext
//        hostingVC.view.backgroundColor = UIColor.clear
//        hostingVC.modalTransitionStyle = .crossDissolve
        
        if isPresented.wrappedValue && !targetHidden.wrappedValue {
                    
            //let viewController = self.topViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + EventStatusView.animationDuration + 0.1) {
                let image = topWindow?.asImage(rect: CGRect(origin: rect.origin, size: rect.size))
                
                let hostingVC = UIHostingController(rootView: ContextView(image: image!, rect: rect, visible: isPresented, targetHidden: targetHidden))
                hostingVC.modalPresentationStyle = .overCurrentContext
                hostingVC.view.backgroundColor = UIColor.clear
                hostingVC.modalTransitionStyle = .crossDissolve
                let viewController = self.topViewController()
                viewController?.present(hostingVC, animated: false) {
                    //targetHidden.wrappedValue.toggle()
                }
                //targetHidden.wrappedValue.toggle()
            }
            //viewController?.present(hostingVC, animated: true, completion: nil)
        }
        return self
    }
    
    private var topWindow: UIWindow? {
       for window in UIApplication.shared.windows.reversed() {
           if window.windowLevel == UIWindow.Level.normal && window.isKeyWindow && window.frame != CGRect.zero { return window }
       }
       return nil
   }
    
    private func topViewController(baseVC: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
            
            if let nav = baseVC as? UINavigationController {
                return topViewController(baseVC: nav.visibleViewController)
            }
            if let tab = baseVC as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(baseVC: selected)
                }
            }
            if let presented = baseVC?.presentedViewController {
                return topViewController(baseVC: presented)
            }
            return baseVC
        }
}

extension View {
    
    func showContext(isPresented: Binding<Bool>, targetHidden: Binding<Bool>) -> some View {
        self.background(TargetView(visible: isPresented, targetHidden: targetHidden))
    }
    
    func handleScroll(coordinateSpaceName: String, handler: ((_ rect: CGRect) -> Void)?) -> some View {
        self.background(GeometryGetter2(action: handler, coordinateSpaceName: coordinateSpaceName))
    }
}
