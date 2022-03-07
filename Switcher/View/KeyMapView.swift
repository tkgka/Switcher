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
                                listOfKeyMap.remove(at: index)
                                isChecked.remove(at: index)
                                ListOfKeyMap = listOfKeyMap.reversed()
                                IsChecked = isChecked.reversed()
                            }
                            SetKeyMapValue()
                            listOfKeyMap = ListOfKeyMap.reversed()
                            isChecked = IsChecked.reversed()
                        }
                    }).frame(width: 100)
                    
            Spacer()
        VStack{
            Text(Content.PressedKey)
                .onTapGesture{
                    (Content.PressedKey != "Waiting") ? (Content.PressedKey = "Waiting") : (Content.PressedKey = "PressedKey")
                }
            }.frame(width: 100)
        Text("->")
        VStack{
            Text(Content.ReturnKey)
                .onTapGesture{
                    (Content.ReturnKey != "Waiting") ? (Content.ReturnKey = "Waiting") : (Content.ReturnKey = "ReturnKey")
                }
        }.frame(width: 100)
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
                        Content.PressedKey = "PressedKey"
                        Content.ReturnKey = "ReturnKey"
                        CGEventDict[Content.PressedKeyEvent!] = Content.ReturnKeyEvent!
                        print(CGEventDict)
                    }
                }).frame(width: 100)
                
    }
.padding([.top], 20.0)
            Divider()

            List {
                ForEach (0..<CGEventDict.count, id: \.self) { Val in
                    let i:Int = Val
            HStack{
                VStack{
                HStack{
//                Toggle(isOn: $isChecked[i]) {}.frame(width: 50)
                Spacer()
                    Text("!@3")
//                Text(listOfKeyMap[i][1]).frame(width: 30)
//                Text(listOfKeyMap[i][0]).frame(width: 100)
//                Text(":")
//                Text(listOfKeyMap[i][3]).frame(width: 80)
//                Text(listOfKeyMap[i][2]).frame(width: 100)
                Spacer()
                }
                }
            }
        }
    }
    }.frame(width: 1200, height: 500, alignment: .center)
}
}
