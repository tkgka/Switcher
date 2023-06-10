//
//  TestView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/03/04.
//

import SwiftUI


struct KeyInputView: View {
    let Add_Item_Key:LocalizedStringKey = "Add_Item_Key"
    let Remove_Item_Key:LocalizedStringKey = "Remove_Item_Key"
    
    @ObservedObject var Content = observedKeyVal
    @AppStorage("IsChecked") var isChecked:[Bool] = [Bool](rawValue: UserDefaults.standard.string(forKey: "IsChecked")!) ?? []
    var body: some View {
        HStack {
            ZStack {
                Text(Remove_Item_Key)
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    )
                    .padding([.top, .bottom] , 2)
            } .onTapGesture(count: 1, perform: {
                for (index, value) in isChecked.enumerated().reversed() {
                    if(value == true){
                        RemoveDataToEventDict(index: index)
                        
                    }
                }
            }).frame(width: 100)
            
            Spacer()
            VStack {
                Text(Content.pressedKey)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture {
                        (Content.pressedKey != "Waiting")
                        ? ((Content.pressedKey = "Waiting"), (nil))
                        : ((Content.pressedKey = "PressedKey"), (Content.pressedKeyEvent = nil))
                    }
            }.frame(width: 180, alignment: .trailing)
            Text(":")
            VStack{
                Text(Content.returnKey)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture {
                        (Content.returnKey != "Waiting")
                        ? ((Content.returnKey = "Waiting"), (nil))
                        : ((Content.returnKey = "ReturnKey"), (Content.returnKeyEvent = nil))
                    }
            }.frame(width: 180, alignment: .leading)
            Spacer()
            ZStack {
                Text(Add_Item_Key)
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    )
                    .padding(.trailing , 8.0)
            }.onTapGesture(count: 1, perform: {
                if Content.pressedKeyEvent != nil && Content.returnKeyEvent != nil{
                    appendDataToEventDict()
                }
            }).frame(width: 100)
        }
    }
    func appendDataToEventDict() {
        Content.pressedKey = "PressedKey"
        Content.returnKey = "ReturnKey"
        Content.EventDict[Content.pressedKeyEvent!] = Content.returnKeyEvent!
        isChecked.append(false)
        Content.pressedKeyEvent = nil
        Content.returnKeyEvent = nil
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
    
    func RemoveDataToEventDict(index:Int) {
        Content.EventDict.removeValue(forKey: Array(Content.EventDict.keys)[index])
        isChecked.remove(at: index)
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
}
