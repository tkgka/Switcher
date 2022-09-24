//
//  AppendAppView.swift
//  Switcher
//
//  Created by 김수환 on 2022/06/11.
//

import SwiftUI

struct AppendAppView: View {
    let Add_Item_Key:LocalizedStringKey = "Add_Item_Key"
    let Remove_Item_Key:LocalizedStringKey = "Remove_Item_Key"
    
    let Setted_Application:LocalizedStringKey = "Setted_Application"
    let Currently_running_Application:LocalizedStringKey = "Currently_running_Application"
    let Setted_Application_Empty:LocalizedStringKey = "Setted_Application_Empty"
    
    @State var Icons = ApplicationIcons()
    @ObservedObject var Content = ObservedAlertVals
    @State var SelectedItem:[String] = []
    @State var RemovingItem:[String] = []
    var body: some View {
        HStack{
            VStack{
                Text(Setted_Application)
                List {
                    if Content.AlertList.count == 0{
                        Text(Setted_Application_Empty)
                    }else{ForEach(Content.AlertList.keys.sorted(), id: \.self) { val in
                        HStack{
                            Image(nsImage: Content.AlertList[val]!).resizable().frame(width: 32, height: 32)
                            Text(val)
                        }.frame(width: 250,alignment: .leading)
                            .background(RemovingItem.contains(val) ? Color.red.opacity(0.5) : nil)
                            .onTapGesture{
                                if(!RemovingItem.contains(val)){
                                    RemovingItem.append(val)
                                }else{
                                    RemovingItem.removeAll(where: {$0 == val})
                                }
                            }
                    }}
                }
            }
            VStack{
                Text(Add_Item_Key)
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    ).onTapGesture{
                        if SelectedItem.count > 0 {
                            for item in SelectedItem {
                                Content.AlertList[item] = Icons[item]
                            }
                            StringImg2StringData()
                            SelectedItem.removeAll()
                        }
                    }

                Text(Remove_Item_Key)
                    .frame(width: 60, alignment: .center)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    ).onTapGesture{
                        if RemovingItem.count > 0 {
                            for item in RemovingItem {
                                Content.AlertList.removeValue(forKey: item)
                            }
                            StringImg2StringData()
                            RemovingItem.removeAll()
                        }
                    }
            }
            
            
            VStack{
                HStack{
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .onTapGesture{
                            Icons = ApplicationIcons()
                        }
                    Spacer()
                    Text(Currently_running_Application)
                    Spacer()
                }
                List {
                    ForEach(Icons.keys.sorted(), id: \.self) { val in
                        HStack{
                            Image(nsImage: Icons[val]!)
                            Text(val)
                        }.frame(width: 250,alignment: .leading)
                            .background(SelectedItem.contains(val) ? Color.blue.opacity(0.5) : nil)
                            .onTapGesture{
                                if(!SelectedItem.contains(val)){
                                    SelectedItem.append(val)
                                }else{
                                    SelectedItem.removeAll(where: {$0 == val})
                                }
                            }
                    }
                }
            }
        }
    }
    func StringImg2StringData(){
        var saveToUserDefaultsVal:[String:Data] = [:]
        for name in Content.AlertList.keys {
            saveToUserDefaultsVal[name] = Content.AlertList[name]?.png
        }
        UserDefaults.standard.set(try? JSONEncoder().encode(saveToUserDefaultsVal), forKey:"AlertList")
    }
}
