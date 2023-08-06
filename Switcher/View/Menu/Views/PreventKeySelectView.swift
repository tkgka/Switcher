//
//  PreventKeySelectView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import SwiftUI

struct PreventKeySelectView: View {
    
    @ObservedObject var model = PreventKeyModel.shared
    
    var body: some View {
        Spacer(minLength: 3.0)
        HStack {
            Spacer(minLength: 3.0)
            Button {
                
            } label: {
                ZStack {
                    Text("Remove_Item_Key".localized)
                        .frame(width: 60, alignment: .center)
                        .padding(7)
                }
            }
            
            Spacer()
            VStack {
                var text: String {
                    if let newValue = model.newValue {
                        let flagText = String(
                            newValue.flags.sortedString
                        )
                        return "\(flagText) \(newValue.key.string)"
                    }
                    guard model.isAddingNewValue else {
                        return "PressToAddNewKey"
                    }
                    return "waiting"
                }
                Text(text)
                    .font(.system(size: 13, weight: .semibold))
                    .onTapGesture {
                        model.newValue = nil
                        model.isAddingNewValue.toggle()
                    }
            }.frame(width: 180, alignment: .center)
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    Text("Add_Item_Key".localized)
                        .frame(width: 60, alignment: .center)
                        .padding(7)
                }
            }
            Spacer(minLength: 3.0)
        }
        Spacer(minLength: 3.0)
    }
    func appendDataToEventDict() {
        // TODO: - Implement
    }
    
    func RemoveDataToEventDict(index:Int) {
        // TODO: - Implement
    }
}
