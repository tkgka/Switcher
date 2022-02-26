//
//  ContentView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/02/12.
//

import SwiftUI

struct KeyMapView: View {
    @AppStorage("ListOfKeyMap") var ListOfKeyMap:[[String]] = [["a","Any","a","Any"]]
    @State var KeyMapList:[String] = ["","Any","","Any"]
    @AppStorage("IsChecked") var IsChecked:[Bool] = [false]
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
                        for (index, value) in IsChecked.enumerated().reversed(){
                            if(value == true){
                                ListOfKeyMap.remove(at: index)
                                IsChecked.remove(at: index)
                            }
                            
                        }
                    }).frame(width: 100)
                    
            Spacer()
            VStack {
                Form {
                    Section{
                        Picker("", selection: ($KeyMapList[1])){
                            ForEach(Flags, id: \.self){
                                Text($0)
                            }
                        }
                    }
                }
                }.frame(width: 80)
                VStack{
                        Form {
                            Section {
                                Picker("", selection: ($KeyMapList[0])) {
                                    ForEach(KeyMapsArr, id: \.self) {
                                        Text($0)
                                    }
                                }
                            }
                        }
            }.frame(width: 100)
                Text(":")
        VStack{
                Form {
                    Section{
                        Picker("", selection: ($KeyMapList[3])){
                            ForEach(Flags, id: \.self){
                                Text($0)
                            }
                        }
                    }
                }
                }.frame(width:80)
        VStack{
            Form {
                Section {
                    Picker("", selection: ($KeyMapList[2])) {
                        ForEach(KeyMapsArr, id: \.self) {
                            Text($0)
                        }
                    }
                }
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
                    if(KeyMapList[0] != "" && KeyMapList[2] != ""){
                    (KeyMaps[KeyMapList[2]]! >= 96 && KeyMaps[KeyMapList[2]]! <= 122) ? (KeyMapList[3] = "Fn") : nil
                    ListOfKeyMap.append(KeyMapList)
                    IsChecked.append(false)
                    KeyMapList = ["","Any","","Any"]
                    }
                }).frame(width: 100)
                
    }
.padding([.top], 20.0)
            Divider()

            List {
                ForEach (0..<ListOfKeyMap.count, id: \.self) { Val in
                    let i:Int = Val
            HStack{
                VStack{
                HStack{
                Toggle(isOn: $IsChecked[i]) {}.frame(width: 50)
                Spacer()
                Text(ListOfKeyMap[i][1]).frame(width: 30)
                Text(ListOfKeyMap[i][0]).frame(width: 100)
                Text(":")
                Text(ListOfKeyMap[i][3]).frame(width: 80)
                Text(ListOfKeyMap[i][2]).frame(width: 100)
                Spacer()
                }
                }
            }
        }
    }
            HStack{
           Text("set value")
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                    )
                    .padding([.leading, .bottom], 8.0)
                
   } .onTapGesture(count: 1, perform: {
       IsflagsChanged.removeAll()
       KeyDict.removeAll()
       for (index, value) in ListOfKeyMap.enumerated().reversed(){
           if((value[0] == "" || value[2] == "") || (KeyDict[KeyMaps[value[0]]!] != nil)){
               if FlagMaps[value[1]]![0] == 0x00 { // if Keys Flag == Any
                   ListOfKeyMap.removeAll(where: {$0[0] == value[0] && $0 != value})
                   IsChecked.remove(at: index)
               }
               else if (FlagMaps[value[1]]![0] == KeyDict[KeyMaps[value[0]]!]![0] || KeyDict[KeyMaps[value[0]]!]![0] == 0x00){
                   ListOfKeyMap.remove(at: index)
                   IsChecked.remove(at: index)
               }
           }else{
               KeyDict[KeyMaps[value[0]]!] = [FlagMaps[value[1]]![0],FlagMaps[value[1]]![1],KeyMaps[value[2]]!,KeyMaps[value[3]]!] // (0,1): keysFlag, 2: MappedKeyVal, 3: MappedKeysFlag
           }
       }
       if IsChecked.count != ListOfKeyMap.count {
           IsChecked.removeAll()
           for _ in (1...ListOfKeyMap.count){
               IsChecked.append(false)
           }
       }
   })
   .frame(height: 32.0)
    }.frame(width: 1200, height: 500, alignment: .center)
}
}
