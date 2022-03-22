//
//  TestView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/03/04.
//

import SwiftUI

struct Fruit: Identifiable {
  let id = UUID().uuidString
  let name: String
}

final class ViewModel: ObservableObject {
  init(fruits: [Fruit] = ViewModel.defaultFruits) {
    self.fruits = fruits
    self.selectedId = fruits[0].id
  }
  @Published var fruits: [Fruit]
  @Published var selectedId: String?
  static let defaultFruits: [Fruit] = ["Key", "Button"].map({ Fruit(name: $0) })
}



struct TestView: View {
  @StateObject var viewModel = ViewModel()
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.fruits) { item in
          NavigationLink(item.name, tag: item.id, selection: $viewModel.selectedId) {
              
              VStack{
                  if item.name == viewModel.fruits[0].name{
                      KeyInputView()
                  }
                  else if item.name == viewModel.fruits[1].name{
                      KeyInputListView()
                  }
                  KeyMapsView()
              
              }
          }
        }
      }
      .listStyle(.sidebar)
            
      Text("No selection")
    }.frame(width: 1350, height: 520)
  }
}



struct KeyInputListView: View {
    @State var KeyMapList:[String] = ["",""]
    @State var showingPopover:[Bool] = [false,false]
    @ObservedObject var Content = ObservedObjects
    @AppStorage("IsChecked") var isChecked:[Bool] = [false]
    @State var allItems:[UInt] = Array(FlagMaps.keys).sorted()
    var body: some View{
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
                            Image(systemName: "\($Content.PressedKeyList.count).circle")
                                .font(.title2)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                    }
                    .popover(isPresented: $showingPopover[0]) {
                        MultiSelectPickerView(allItems: allItems, selectedItems: $Content.PressedKeyList)
                        // If you have issues with it being too skinny you can hardcode the width
                         .frame(width: 300)
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
                Section {
                    Button(action: {
                        // The only job of the button is to toggle the showing
                        // popover boolean so it pops up and we can select our items
                        showingPopover[1].toggle()
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "\($Content.ReturnKeyList.count).circle")
                                .font(.title2)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                        }
                        .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                    }
                    .popover(isPresented: $showingPopover[1]) {
                        MultiSelectPickerView(allItems: allItems, selectedItems: $Content.ReturnKeyList)
                        // If you have issues with it being too skinny you can hardcode the width
                         .frame(width: 300)
                    }
                }
            }
            }.frame(width:80)
    VStack{
        Form {
            Section {
                Picker("", selection: ($KeyMapList[1])) {
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
                if KeyMaps.findKey(forValue: KeyMapList[0]) != nil && KeyMaps.findKey(forValue: KeyMapList[1]) != nil{
                    appendDataToEventDict()
                }
                
            }).frame(width: 100)
            
}
        HStack() {
            // Rather than a picker we're using Text for the label
            // and a button for the picker itself
            Text("Select Items:")
                .foregroundColor(.white)
            Text(ObservedObjects.PressedKeyList.rawValue)
            Text(ObservedObjects.ReturnKeyList.rawValue)
            
        }
    }
    func appendDataToEventDict(){
        Content.PressedKeyEvent = PressedKeyEventStringMaker(keycode: KeyMaps.findKey(forValue: KeyMapList[0])!, Flag: ArrayToFlagVal(val: Content.PressedKeyList))
        Content.ReturnKeyEvent = EventStruct(keys: KeyMaps.findKey(forValue: KeyMapList[1]), FlagNum: ArrayToFlagVal(val: Content.ReturnKeyList))
        Content.EventDict[Content.PressedKeyEvent!] = Content.ReturnKeyEvent!
        Content.PressedKeyList = []
        Content.ReturnKeyList = []
        Content.PressedKeyEvent = nil
        Content.ReturnKeyEvent = nil
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
        KeyMapList = ["",""]
    }
    func RemoveDataToEventDict(index:Int) {
        Content.EventDict.removeValue(forKey: Array(Content.EventDict.keys)[index])
        isChecked.remove(at: index)
        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
}


struct KeyInputView: View {
    @ObservedObject var Content = ObservedObjects
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

struct KeyMapsView: View {
    @AppStorage("IsChecked") var isChecked:[Bool] = [false]
    @ObservedObject var Content = ObservedObjects
    var body: some View {
        VStack{
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
                    let PressedFlagString = GetFlags(Val: UInt(DictKey[i].components(separatedBy: "|")[1])!)
                    HStack{
                        Text(PressedFlagString)
                        if KeyMaps[UInt16(DictKey[i].components(separatedBy: "|")[0])!] != nil {
                            Text(KeyMaps[UInt16(DictKey[i].components(separatedBy: "|")[0])!]!)
                        }else {
                            Text(DictKey[i].components(separatedBy: "|")[0])
                        }
                    }.frame(width: 250, alignment: .trailing)
                    Text(":")
                    let ReturnFlagString = GetFlags(Val: UInt(Content.EventDict[DictKey[i]]!.FlagNum))
                    HStack{
                        if KeyMaps[Array(Content.EventDict.values)[i].keys] != nil{
                            Text(KeyMaps[Array(Content.EventDict.values)[i].keys]!)
                        }else{
                            Text(String(Array(Content.EventDict.values)[i].keys))
                        }
                    Text(ReturnFlagString)
                    }.frame(width: 250, alignment: .leading)
                Spacer()
                }
                }
            }.padding([.top], 20.0)
        }
    }
    }.frame(width: 1200, height: 450, alignment: .center)
}
}
