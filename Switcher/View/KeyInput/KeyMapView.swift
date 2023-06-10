//
//  ContentView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/02/12.
//

import SwiftUI
struct KeyMapView: View {
    @AppStorage("IsChecked") var isChecked:[Bool] = []
    @ObservedObject var Content = observedKeyVal
    
    var body: some View {
        
        VStack{
            Divider()
            List {
                let DictKey:Array = Array(Content.EventDict.keys)
                ForEach (0..<Content.EventDict.count, id: \.self) { Val in
                    let i:Int = Val
                    HStack {
                        VStack {
                            HStack {
                                Toggle(isOn: $isChecked[i]) {}.frame(width: 15)
                                Spacer()
                                let PressedFlagString = getFlags(val: UInt(DictKey[i].components(separatedBy: "|")[1])!)
                                HStack {
                                    Text(PressedFlagString)
                                    if keyMaps[UInt16(DictKey[i].components(separatedBy: "|")[0])!] != nil {
                                        Text(keyMaps[UInt16(DictKey[i].components(separatedBy: "|")[0])!]!)
                                    }else {
                                        Text(DictKey[i].components(separatedBy: "|")[0])
                                    }
                                }.frame(width: 235, alignment: .trailing)
                                    .font(.system(size: 13, weight: .semibold))
                                Text(":")
                                let ReturnFlagString = getFlags(val: UInt(Content.EventDict[DictKey[i]]!.flagNum))
                                HStack {
                                    if keyMaps[Array(Content.EventDict.values)[i].keys] != nil {
                                        Text(keyMaps[Array(Content.EventDict.values)[i].keys]!)
                                    } else {
                                        Text(String(Array(Content.EventDict.values)[i].keys))
                                    }
                                    Text(ReturnFlagString)
                                }.frame(width: 250, alignment: .leading)
                                    .font(.system(size: 13, weight: .semibold))
                                Spacer()
                            }
                        }
                    }.padding([.top], 20.0)
                }
            }
        }.frame(width: 600, height: 350, alignment: .center)
    }
}




struct ViewData: Identifiable {
    let id = UUID().uuidString
    let name: String
}

final class ViewModel: ObservableObject {
    init(Datas: [ViewData] = ViewModel.defaultDatas, AlertDatas: [ViewData] = ViewModel.AlertDatasModel) {
        self.Datas = Datas
        self.AlertDatas = AlertDatas
        self.selectedId = Datas[0].id
        self.selectedAlertDataId = AlertDatas[0].id
    }
    @Published var Datas: [ViewData]
    @Published var AlertDatas: [ViewData]
    @Published var selectedId: String?
    @Published var selectedAlertDataId: String?
    static let defaultDatas: [ViewData] = ["Key", "Picker"].map({ ViewData(name: $0) })
    static let AlertDatasModel: [ViewData] = ["Apps", "Keys"].map({ ViewData(name: $0) })
    
}


struct MainKeyMapView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.Datas) { item in
                    NavigationLink(item.name, tag: item.id, selection: $viewModel.selectedId) {
                        
                        VStack{
                            if item.name == viewModel.Datas[0].name{
                                KeyInputView()
                            }
                            else if item.name == viewModel.Datas[1].name{
                                KeySelecterView()
                            }
                            KeyMapView()
                            
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        }.frame(width: 750, height: 420)
    }
}
