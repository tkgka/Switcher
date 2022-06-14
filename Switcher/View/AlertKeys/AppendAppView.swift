//
//  AppendAppView.swift
//  Switcher
//
//  Created by 김수환 on 2022/06/11.
//

import SwiftUI

struct AppendAppView: View {
    @State var Icons = ApplicationIcons()
    @ObservedObject var Content = ObservedAlertVals
    @State var SelectedItem:[String] = []
    @State var RemovingItem:[String] = []
    var body: some View {
        HStack{
            VStack{
                Text("Alert")
                List {
                    if Content.AlertList.count == 0{
                        Text("Alert will show in all Application")
                    }else{ForEach(Content.AlertList.keys.sorted(), id: \.self) { val in
                        HStack{
                            Image(nsImage: Content.AlertList[val]!)
                            Text(val)
                        }.frame(width: 250,alignment: .leading)
                        .background(RemovingItem.contains(val) ? Color.red.opacity(0.5) : nil)
                        .onTapGesture{
//                            SelectedItem.removeAll()
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
            Text("Add item")
                .frame(width: 60)
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                ).onTapGesture{
                    for item in SelectedItem {
                        Content.AlertList[item] = Icons[item]
                        print(Icons[item]!)
                    }
                    SelectedItem.removeAll()
                }
//                Image(nsImage: NSImage(contentsOf: URL(fileURLWithPath: "/Users/gimsuhwan/Library/Developer/Xcode/DerivedData/Switcher-blxscdsgfudxndbdqfcyaqputlke/Build/Products/Debug/Switcher.app/Contents/Resources/AppIcon.icns"))!)
            Text("Remove")
                .frame(width: 60)
                .padding(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                ).onTapGesture{
                    for item in RemovingItem {
                        Content.AlertList.removeValue(forKey: item)
                    }
                    RemovingItem.removeAll()
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
                    Text("Currently Running")
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
//                            SelectedItem.removeAll()
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
}
