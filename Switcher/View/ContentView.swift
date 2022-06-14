//
//  ContentView.swift
//  CQ
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI

public struct EffectsView: NSViewRepresentable {
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
struct ContentView: View {
    @State var scale: CGFloat = 1
    let AlertTimeout:Double = 1
    let width = NSScreen.main?.frame.width
    let height = NSScreen.main?.frame.height
    var body: some View {
        VStack{
            ZStack{
                EffectsView()
                VStack{
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 70.0, height: 70.0)
                        .foregroundColor(Color("ImageColor"))
                        .padding()
                    Text("Enter 􀆔q again \nto shutdown app")
                        .kerning(-0.5)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .foregroundColor(Color("FontColor"))
                }
            }.frame(width: AlertSize, height: AlertSize)
                .cornerRadius(20)
                .position(x: width!/2, y: height! - AlertSize*3/2.04)
                .opacity(scale)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + AlertTimeout) {
                        let baseAnimation = Animation.easeIn(duration: DefaultTimeout - AlertTimeout)
                        let repeated = baseAnimation.repeatCount(1, autoreverses: false)
                        withAnimation(repeated) {
                            scale = 0.0
                        }
                    }
                }
        }.frame(width: width!, height:height!)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

