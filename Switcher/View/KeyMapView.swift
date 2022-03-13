//
//  ContentView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/02/12.
//

import SwiftUI
struct KeyMapView: View {
    @AppStorage("ListOfKeyMap") var listOfKeyMap:[[String]] = [["a","Any","a","Any"]]
    @State var KeyMapList:[String] = ["","Any","","Any"]
    @State var DictKeys:[String] = Array(EventDict.keys)
    @State var DictValues:[EventStruct] = Array(EventDict.values)
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
                    (Content.PressedKey != "Waiting") ? (Content.PressedKey = "Waiting") : (Content.PressedKey = "PressedKey")
                }
            }.frame(width: 150)
        Text("->")
        VStack{
            Text(Content.ReturnKey)
                .onTapGesture{
                    (Content.ReturnKey != "Waiting") ? (Content.ReturnKey = "Waiting") : (Content.ReturnKey = "ReturnKey")
                }
        }.frame(width: 150)
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
            ForEach (0..<DictKeys.count, id: \.self) { Val in
                    let i:Int = Val
            HStack{
                VStack{
                HStack{
                Toggle(isOn: $isChecked[i]) {}.frame(width: 15)
                Spacer()
                    let PressedVal = FuncNumToText()
                    let _ = PressedVal.FlagNumToString(Val: Int(DictKeys[i].components(separatedBy: "|")[1])!)
                    HStack{
                        Text(PressedVal.ReturnVal.rawValue)
                        Text(KeyMaps[UInt16(DictKeys[i].components(separatedBy: "|")[0])!]!)
                    }.frame(width: 250, alignment: .trailing)
                    Text(":")
                    let ReturnVal = FuncNumToText()
                    let _ = ReturnVal.FlagNumToString(Val: Int(EventDict[DictKeys[i]]!.FlagNum))
                    HStack{
                     Text(KeyMaps[DictValues[i].keys]!)
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
    EventDict[Content.PressedKeyEvent!] = Content.ReturnKeyEvent!
    isChecked.append(false)
    DictKeys = Array(EventDict.keys)
    DictValues = Array(EventDict.values)
    Content.PressedKeyEvent = nil
    Content.ReturnKeyEvent = nil
    
}

func RemoveDataToEventDict(index:Int) {
    EventDict.removeValue(forKey: DictKeys[index])
//  UserDefaults.standard.set(EventDict, forKey: "EventDict")
    isChecked.remove(at: index)
    DictKeys = Array(EventDict.keys)
    DictValues = Array(EventDict.values)
}
    
}
