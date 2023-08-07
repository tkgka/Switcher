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
        Spacer(minLength: Metric.minimumSpacing)
        HStack {
            Spacer(minLength: Metric.minimumSpacing)
            Button {
                
            } label: {
                ZStack {
                    Text(Texts.removeButton)
                        .frame(width: Metric.Button.width, alignment: .center)
                        .padding(Metric.Button.padding)
                }
            }
            
            Spacer()
            VStack {
                var text: String {
                    if let newValue = model.newValue {
                        return Texts.newValue(newValue)
                    }
                    guard model.isAddingNewValue else {
                        return Texts.pressToAddNewKey
                    }
                    return Texts.waiting
                }
                Text(text)
                    .font(.system(size: Metric.fontSize, weight: .semibold))
                    .onTapGesture {
                        model.newValue = nil
                        model.isAddingNewValue.toggle()
                    }
            }.frame(width: Metric.defaultWidth, alignment: .center)
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    Text(Texts.addButton)
                        .frame(width: Metric.Button.width, alignment: .center)
                        .padding(Metric.Button.padding)
                }
            }
            Spacer(minLength: Metric.minimumSpacing)
        }
        Spacer(minLength: Metric.minimumSpacing)
    }
    func appendDataToEventDict() {
        // TODO: - Implement
    }
    
    func RemoveDataToEventDict(index:Int) {
        // TODO: - Implement
    }
}


// MARK: - Constant

private extension PreventKeySelectView {
    
    enum Metric {
        static let defaultWidth = 180.0
        static let minimumSpacing = 3.0
        static let fontSize = 13.0
        
        enum Button {
            static let width = 60.0
            static let padding = 7.0
        }
    }
    
    enum Texts {
        static let removeButton = "Remove_Item_Key".localized
        static let addButton = "Add_Item_Key".localized
        static let pressToAddNewKey = "PressToAddNewKey".localized
        static let waiting = "waiting".localized
        
        static func newValue(_ value: PreventedKey) -> String {
            return "\(value.flags.sortedString) \(value.key.string)"
        }
    }
}
