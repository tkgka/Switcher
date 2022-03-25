//
//  ContentView.swift
//  KeyMapper
//
//  Created by 김수환 on 2022/02/12.
//

import SwiftUI
struct KeyMapView: View {
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
                    }.frame(width: 235, alignment: .trailing)
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




struct ViewData: Identifiable {
  let id = UUID().uuidString
  let name: String
}

final class ViewModel: ObservableObject {
  init(Datas: [ViewData] = ViewModel.defaultDatas) {
    self.Datas = Datas
    self.selectedId = Datas[0].id
  }
  @Published var Datas: [ViewData]
  @Published var selectedId: String?
  static let defaultDatas: [ViewData] = ["Key", "Picker"].map({ ViewData(name: $0) })
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
                      KeyInputListView()
                  }
                  KeyMapView()
              
              }
          }
        }
      }
      .listStyle(.sidebar)
            
      Text("No selection")
    }.frame(width: 1350, height: 520)
  }
}
