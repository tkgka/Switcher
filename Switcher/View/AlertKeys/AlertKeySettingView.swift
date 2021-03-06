//
//  AlertKeySettingView.swift
//  Switcher
//
//  Created by κΉμν on 2022/06/10.
//

import SwiftUI

struct AlertKeySettingView: View {
    @State var KeyMapList:[String] = ["",""]
    @State var showingPopover:[Bool] = [false,false]
    @ObservedObject var Content = ObservedAlertVals
    @AppStorage("IsChecked") var isChecked:[Bool] = [false]
    @State var allItems:[UInt] = Array(FlagMaps.keys).sorted()
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.AlertDatas) { item in
                    NavigationLink(item.name, tag: item.id, selection: $viewModel.selectedAlertDataId) {
                        if item.name == viewModel.AlertDatas[0].name{
                            AppendAppView().padding(.top, 10)
                        }
                        else if item.name == viewModel.AlertDatas[1].name{
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
                                            (Content.PressedKey != "Waiting") ? (Content.PressedKey = "Waiting") : (Content.PressedKey = "AlertKey")
                                        }
                                }.frame(width: 180, alignment: .center)
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
                                    appendDataToEventDict()
                                }).frame(width: 100)
                            }
                            .padding(.top, 10)
                            VStack{
                                Divider()
                                
                                List {
                                    //                let DictKey:Array = Array(Content.EventDict.keys)
                                    ForEach (0..<(Content.PressedKeyEvent.count ?? 0), id: \.self) { Val in
                                        let i:Int = Val
                                        HStack{
                                            VStack{
                                                HStack{
                                                    Toggle(isOn: $isChecked[i]) {}.frame(width: 15)
                                                    Spacer()
                                                    HStack{
                                                        Text("\(Content.PressedKeyEvent[i])")
                                                    }.frame(width: 235, alignment: .trailing)
                                                        .font(.system(size: 13, weight: .semibold))
                                                }
                                            }
                                        }.padding([.top], 20.0)
                                    }
                                }
                                
                            }.frame(width: 600, height: 350, alignment: .center)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }.frame(width: 750, height: 420)
    }
    
    func appendDataToEventDict(){
        
        if (Content.PressedKey != "AlertKey" && Content.PressedKey != "Waiting" && !Content.PressedKeyEvent.contains(Content.PressedKey)) {
            Content.PressedKeyEvent.append(Content.PressedKey)
            Content.PressedKey = "PressedKey"
            isChecked.append(false)
            UserDefaults.standard.set(Content.PressedKeyEvent, forKey:"AlertValEvent")
            //        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
        }
    }
    
    func RemoveDataToEventDict(index:Int) {
        Content.PressedKeyEvent.remove(at: index)
        isChecked.remove(at: index)
        UserDefaults.standard.set(Content.PressedKeyEvent, forKey:"AlertValEvent")
        //        UserDefaults.standard.set(try? JSONEncoder().encode(Content.EventDict), forKey:"EventDict")
    }
}
