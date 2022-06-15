//
//  TestView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/03/04.
//

import SwiftUI


struct KeyInputView: View {
    @ObservedObject var Content = ObservedKeyVals
    @AppStorage("IsChecked") var isChecked:[Bool] = [false]
    var body: some View {
        HStack{
            ZStack{
                Text("Remove")
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    )
                    .padding([.top, .bottom] , 2)
            } .onTapGesture(count: 1, perform: {
                for (index, value) in isChecked.enumerated().reversed(){
                    if(value == true){
                        RemoveDataToEventDict(index: index)
                        
                    }
                }
            }).frame(width: 100)
            
            Spacer()
            VStack{
                Text(Content.PressedKey)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture{
                        (Content.PressedKey != "Waiting") ? ((Content.PressedKey = "Waiting"), (nil)) : ((Content.PressedKey = "PressedKey"), (Content.PressedKeyEvent = nil))
                    }
            }.frame(width: 180, alignment: .trailing)
            Text(":")
            VStack{
                Text(Content.ReturnKey)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture{
                        (Content.ReturnKey != "Waiting") ? ((Content.ReturnKey = "Waiting"), (nil)) : ((Content.ReturnKey = "ReturnKey"), (Content.ReturnKeyEvent = nil))
                    }
            }.frame(width: 180, alignment: .leading)
            Spacer()
            ZStack{
                Text("Add item")
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    )
                    .padding(.trailing , 8.0)
            }.onTapGesture(count: 1, perform: {
                if Content.PressedKeyEvent != nil && Content.ReturnKeyEvent != nil{
                    appendDataToEventDict()
                }
            }).frame(width: 100)
        }
    }
    func appendDataToEventDict(){
        Content.PressedKey = "PressedKey"
        Content.ReturnKey = "ReturnKey"
        Content.EventDict[Content.PressedKeyEvent!] = Content.ReturnKeyEvent!
        isChecked.append(false)
        Content.PressedKeyEvent = nil
        Content.ReturnKeyEvent = nil
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
    
    func RemoveDataToEventDict(index:Int) {
        Content.EventDict.removeValue(forKey: Array(Content.EventDict.keys)[index])
        isChecked.remove(at: index)
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
}


