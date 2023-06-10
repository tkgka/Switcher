//
//  KeySelecterView.swift
//  Switcher
//
//  Created by 김수환 on 2022/05/09.
//

import SwiftUI

struct KeySelecterView: View {
    let Add_Item_Key:LocalizedStringKey = "Add_Item_Key"
    let Remove_Item_Key:LocalizedStringKey = "Remove_Item_Key"
    
    @State var KeyMapList:[String] = ["",""]
    @State var showingPopover:[Bool] = [false,false]
    @ObservedObject var Content = observedKeyVal
    @AppStorage("IsChecked") var isChecked:[Bool] = [Bool](rawValue: UserDefaults.standard.string(forKey: "IsChecked")!) ?? []
    @State var allItems:[UInt] = Array(flagMaps.keys).sorted()
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
                Form {
                    Section {
                        Button(action: {
                            // The only job of the button is to toggle the showing
                            // popover boolean so it pops up and we can select our items
                            showingPopover[0].toggle()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "\($Content.pressedKeyList.count).circle")
                                    .font(.title2)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                        }
                        .popover(isPresented: $showingPopover[0]) {
                            MultiSelectPickerView(allItems: allItems, selectedItems: $Content.pressedKeyList)
                            // If you have issues with it being too skinny you can hardcode the width
                                .frame(width: 300)
                        }
                    }
                }
            }.frame(width: 50)
            VStack{
                Form {
                    Section {
                        Picker("", selection: ($KeyMapList[0])) {
                            ForEach(keyMaps.values.sorted(by: {$0 < $1}), id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }.frame(width: 80)
            Text(":")
            VStack{
                Form {
                    Section {
                        Button(action: {
                            // The only job of the button is to toggle the showing
                            // popover boolean so it pops up and we can select our items
                            showingPopover[1].toggle()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "\($Content.returnKeyList.count).circle")
                                    .font(.title2)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                        }
                        .popover(isPresented: $showingPopover[1]) {
                            MultiSelectPickerView(allItems: allItems, selectedItems: $Content.returnKeyList)
                            // If you have issues with it being too skinny you can hardcode the width
                                .frame(width: 300)
                        }
                    }
                }
            }.frame(width:50)
            VStack {
                Form {
                    Section {
                        Picker("", selection: ($KeyMapList[1])) {
                            ForEach(keyMaps.values.sorted(by: {$0 < $1}), id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }
            }.frame(width: 80)
            Spacer()
            ZStack{
                Text(Add_Item_Key)
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    )
                    .padding(.trailing , 8.0)
            }.onTapGesture(count: 1, perform: {
                if keyMaps.findKey(forValue: KeyMapList[0]) != nil && keyMaps.findKey(forValue: KeyMapList[1]) != nil{
                    appendDataToEventDict()
                }
                
            }).frame(width: 100)
        }
    }
    func appendDataToEventDict() {
        Content.pressedKeyEvent = pressedKeyEventStringMaker(keycode: keyMaps.findKey(forValue: KeyMapList[0])!, flag: ArrayToFlagVal(val: Content.pressedKeyList))
        Content.returnKeyEvent = EventStruct(keys: keyMaps.findKey(forValue: KeyMapList[1]), flagNum: ArrayToFlagVal(val: Content.returnKeyList))
        Content.EventDict[Content.pressedKeyEvent!] = Content.returnKeyEvent!
        Content.pressedKeyList = []
        Content.returnKeyList = []
        Content.pressedKeyEvent = nil
        Content.returnKeyEvent = nil
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
        KeyMapList = ["",""]
    }
    func RemoveDataToEventDict(index:Int) {
        Content.EventDict.removeValue(forKey: Array(Content.EventDict.keys)[index])
        isChecked.remove(at: index)
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
}
