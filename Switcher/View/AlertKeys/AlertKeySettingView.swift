//
//  AlertKeySettingView.swift
//  Switcher
//
//  Created by 김수환 on 2022/06/10.
//

import SwiftUI

struct AlertKeySettingView: View {
    let Add_Item_Key:LocalizedStringKey = "Add_Item_Key"
    let Remove_Item_Key:LocalizedStringKey = "Remove_Item_Key"
    
    @State var KeyMapList:[String] = ["",""]
    @State var showingPopover:[Bool] = [false,false]
    @ObservedObject var Content = observedAlertVal
    @AppStorage("AlertKeyListIsChecked") var isChecked:[Bool] = [Bool](rawValue: UserDefaults.standard.string(forKey: "AlertKeyListIsChecked")!) ?? []
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
                                    Text(Remove_Item_Key)
                                        .frame(width: 60, alignment: .center)
                                        .padding(7)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(lineWidth: 2)
                                        )
                                        .padding([.top, .bottom] , 2)
                                } .onTapGesture(count: 1, perform: {
                                    for (index, value) in isChecked.enumerated().reversed(){
                                        if(value == true){
                                            removeDataFromEventDict(index: index)
                                            
                                        }
                                    }
                                }).frame(width: 100)
                                
                                Spacer()
                                VStack{
                                    Text(Content.pressedKey)
                                        .font(.system(size: 13, weight: .semibold))
                                        .onTapGesture{
                                            (Content.pressedKey != "Waiting") ? (Content.pressedKey = "Waiting") : (Content.pressedKey = "AlertKey")
                                        }
                                }.frame(width: 180, alignment: .center)
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
                                    appendDataToEventDict()
                                }).frame(width: 100)
                            }
                            .padding(.top, 10)
                            VStack{
                                Divider()
                                
                                List {
                                    ForEach (0..<(Content.pressedKeyEvent.count), id: \.self) { Val in
                                        let i:Int = Val
                                        HStack{
                                            VStack{
                                                HStack{
                                                    Toggle(isOn: $isChecked[i]) {}.frame(width: 15)
                                                    Spacer()
                                                    HStack{
                                                        Text("\(Content.pressedKeyEvent[i])")
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
        if (Content.pressedKey != "AlertKey" && Content.pressedKey != "Waiting" && !Content.pressedKeyEvent.contains(Content.pressedKey)) {
            Content.pressedKeyEvent.append(Content.pressedKey)
            Content.pressedKey = "AlertKey"
            isChecked.append(false)
            UserDefaults.standard.set(Content.pressedKeyEvent, forKey:"AlertValEvent")
        }
    }
    
    func removeDataFromEventDict(index:Int) {
        Content.pressedKeyEvent.remove(at: index)
        isChecked.remove(at: index)
        UserDefaults.standard.set(Content.pressedKeyEvent, forKey:"AlertValEvent")
    }
}
