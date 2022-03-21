//
//  TestView.swift
//  Switcher
//
//  Created by 김수환 on 2022/03/17.
//

import SwiftUI
struct TestView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.blue)
                .font(Font.system(size: 12.0))
                .fontWeight(.bold)
                .padding(.leading, 15.0)
                .padding(.top, 15.0)
                .frame(alignment: .leading)
                .padding(.bottom, 15.0)
                .onTapGesture{
                KeyMapView().openInWindow(title: "KeyMap", sender: self)
                }.frame(width: 200, height: 200)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
