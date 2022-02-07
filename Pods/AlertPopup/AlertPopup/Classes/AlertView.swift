//
//  ContentView.swift
//  CQ
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI

@available(macOS 10.14, *)
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


@available(macOS 10.15, *)
public struct AlertView: View {
    let ImageName:String!
    let AlertText:String!
    let FontColor:Color!
    let ImageColor:Color!
    @State var scale: CGFloat = 1
    let Timer:Double!
    let AlertTimeout:Double = 0.5
    let width = NSScreen.main?.frame.width
    let height = NSScreen.main?.frame.height
    public var body: some View {
        VStack{
        ZStack{
            BlurView()
            VStack{
                if #available(macOS 11.0, *) {
                    Image(systemName: ImageName)
                        .resizable()
                        .frame(width: 70.0, height: 70.0)
                        .foregroundColor(ImageColor)
                        .padding()
                }
                Text(AlertText).multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .foregroundColor(FontColor)
            }
        }.frame(width: 200, height: 200)
                .cornerRadius(20)
                .position(x: width!/2, y: height! - 200*3/2.04)
                .opacity(scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Timer - AlertTimeout) {
                    let baseAnimation = Animation.easeIn(duration: AlertTimeout)
                    let repeated = baseAnimation.repeatCount(1, autoreverses: false)
                    withAnimation(repeated) {
                        scale = 0.0
                    }
                    }
                }
        }.frame(width: width!, height:height!)
    }
    public init(ImageName:String, AlertText:String, Timer:Double, ImageColor:Color, FontColor:Color){
        self.ImageName = ImageName
        self.AlertText = AlertText
        self.Timer = Timer
        self.FontColor = FontColor
        self.ImageColor = ImageColor
    }
}
