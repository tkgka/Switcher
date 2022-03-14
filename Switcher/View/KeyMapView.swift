//
//  ContentView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/02/12.
//

import SwiftUI
struct KeyMapView: View {
    @AppStorage("IsChecked") var isChecked:[Bool] = [false]
    @ObservedObject var Content = ObservedObjects
    var body: some View {
        VStack{

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
                .onTapGesture{
                    (Content.PressedKey != "Waiting") ? ((Content.PressedKey = "Waiting"), (nil)) : ((Content.PressedKey = "PressedKey"), (Content.PressedKeyEvent = nil))
                }
            }.frame(width: 250, alignment: .trailing)
        Text("->")
        VStack{
            Text(Content.ReturnKey)
                .onTapGesture{
                    (Content.ReturnKey != "Waiting") ? ((Content.ReturnKey = "Waiting"), (nil)) : ((Content.ReturnKey = "ReturnKey"), (Content.ReturnKeyEvent = nil))
                }
        }.frame(width: 250, alignment: .leading)
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
.padding([.top], 20.0)
            Divider()
            List {
            
            let DictKey:Array = Array(Content.EventDict.keys)
            ForEach (0..<Content.EventDict.count, id: \.self) { Val in
                    let i:Int = Val
            HStack{
                VStack{
                HStack{
                Toggle(isOn: $isChecked[i]) {}.frame(width: 15)
                Spacer()
                    let PressedVal = FuncNumToText()
                    let _ = PressedVal.FlagNumToString(Val: Int(DictKey[i].components(separatedBy: "|")[1])!)
                    HStack{
                        Text(PressedVal.ReturnVal.rawValue)
                        Text(KeyMaps[UInt16(DictKey[i].components(separatedBy: "|")[0])!]!)
                    }.frame(width: 250, alignment: .trailing)
                    Text(":")
                    let ReturnVal = FuncNumToText()
                    let _ = ReturnVal.FlagNumToString(Val: Int(Content.EventDict[DictKey[i]]!.FlagNum))
                    HStack{
                     Text(KeyMaps[Array(Content.EventDict.values)[i].keys]!)
                    Text(ReturnVal.ReturnVal.rawValue)
                    }.frame(width: 250, alignment: .leading)
                Spacer()
                }
                }
            }
        }
    }
    }.frame(width: 1200, height: 500, alignment: .center)
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
