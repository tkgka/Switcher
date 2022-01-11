//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import SwiftUI
import AlertToast


struct ContentView: View {
@State public var isEnabled = false
    var body: some View {
        VStack{
            
        }.frame(width: 300, height: 300)
    }
}

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
