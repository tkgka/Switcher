//
//  PreventKeySelectView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import SwiftUI

struct PreventKeySelectView: View {
    
    @ObservedObject private var model = PreventKeyModel.shared
    @State private var toggles: [Bool] = Array(repeating: false, count: PreventKeyModel.shared.preventedKeys.count)
    
    var body: some View {
        VStack {
            Header()
            List {
                ForEach(0 ..< model.preventedKeys.count, id: \.self) { index in
                    HStack{
                        Toggle(Texts.newValue(.init(flags: model.preventedKeys[index].flags, key: model.preventedKeys[index].key)), isOn: $toggles[index])
                    }
                }
            }
        }.frame(height: 300)
    }
    
    func appendDataToEventDict() {
        guard let newValue = model.newValue,
              !model.preventedKeys.contains(newValue)
        else {
            model.newValue = nil
            return
        }
        model.preventedKeys.append(newValue)
        model.newValue = nil
        toggles = Array(repeating: false, count: model.preventedKeys.count)
    }
    
    func RemoveDataFromEventDict() {
        var removeValues = PreventedKeys()
        (0 ..< model.preventedKeys.count).forEach({ index in
            guard toggles[index] else { return }
            removeValues.append(model.preventedKeys[index])
        })
        model.preventedKeys.removeAll(where: { removeValues.contains($0) })
        toggles = Array(repeating: false, count: model.preventedKeys.count)
    }
}


// MARK: - Header

private extension PreventKeySelectView {
    
    @ViewBuilder
    func Header() -> some View {
        Spacer(minLength: Metric.minimumSpacing)
        HStack {
            Spacer(minLength: Metric.minimumSpacing)
            Button {
                RemoveDataFromEventDict()
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
                appendDataToEventDict()
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
