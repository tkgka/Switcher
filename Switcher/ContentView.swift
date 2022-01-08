//
//  ContentView.swift
//  CQ
//
//  Created by 김수환 on 2021/12/31.
//

import SwiftUI
import AlertToast


struct ContentView: View {
@State public var isEnabled = false
    var body: some View {
        VStack{
            Toggle(isOn: $isEnabled) {
                       Text(String(isEnabled))
                   }.keyboardShortcut("t")
        }.frame(width: 300, height: 300)
            .toast(isPresenting: $isEnabled){
                AlertToast(type: .regular, title: "Message Sent!")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//let eventMask = CGEventType.keyDown.rawValue //| (1 << CGEventType.keyUp.rawValue)
//print(eventMask)


prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
