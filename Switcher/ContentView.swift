//
//  ContentView.swift
//  CQ
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI

struct EffectsView: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
      return NSVisualEffectView()
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}

struct ContentView: View {
    let value:Bool = true
    let width = NSScreen.main?.frame.width
    let height = NSScreen.main?.frame.height
    var body: some View {
        VStack{
        ZStack{
            EffectsView()
                .colorMultiply(Color("BGColor"))
                .luminanceToAlpha()

            VStack{
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 70.0, height: 70.0)
                    .foregroundColor(Color.white)
//                    .padding().shadow(color: .white, radius: 20, x: 2, y: 2)
                    .padding()
                Text("Enter 􀆔q again \nto shutdown app").multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .foregroundColor(Color.white)
            }
        }.frame(width: AlertSize, height: AlertSize)
                .cornerRadius(20)
                .position(x: width!/2, y: height! - AlertSize*3/2.04)

        }.frame(width: width!, height:height!)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
