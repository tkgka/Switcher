//
//  ContentView.swift
//  Switcher
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI

public struct BlurView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.blendingMode = .withinWindow
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
        nsView.blendingMode = .withinWindow
    }
}

public struct AlertView: View {
    
    // MARK: - Interface
    
    let alertText:String
    
    
    // MARK: - State
    
    @State var scale: CGFloat = 1
    
    
    // MARK: - View
    
    public var body: some View {
        VStack{
            ZStack{
                BlurView()
                VStack{
                    Image(systemName: ImageName.exclamationmarkCircle)
                        .resizable()
                        .frame(width: Constant.imageSize, height: Constant.imageSize)
                        .foregroundColor(Colors.image)
                        .padding()
                    Text(alertText).multilineTextAlignment(.center)
                        .font(.system(size: Constant.fontSize))
                        .foregroundColor(Colors.font)
                }
            }.frame(width: Constant.viewSize, height: Constant.viewSize)
                .cornerRadius(Constant.cornerRadius)
                .position(x: Metric.width / 2, y: Metric.height - Constant.viewSize * 3 / 2.04)
                .opacity(scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Metric.defaltTimeout - Metric.alertTimeout) {
                        withAnimation(Animation.easeIn(duration: Metric.alertTimeout).repeatCount(1, autoreverses: false)) {
                            scale = 0.0
                        }
                    }
                }
        }.frame(width: Metric.width, height: Metric.height)
    }
}


// MARK: - Constant

private extension AlertView {
    
    enum Constant {
        static let imageSize = 70.0
        static let fontSize = 15.0
        static let viewSize = 200.0
        static let cornerRadius = 20.0
    }
    
    enum Metric {
        static let defaltTimeout:Double = 1.5
        static let alertTimeout:Double = 0.5
        static let width = NSScreen.main?.frame.width ?? 0
        static let height = NSScreen.main?.frame.height ?? 0
    }
    
    enum Colors {
        static let font = Color("FontColor")
        static let image = Color("ImageColor")
    }
    
    enum ImageName {
        static let exclamationmarkCircle = "exclamationmark.circle"
    }
}
