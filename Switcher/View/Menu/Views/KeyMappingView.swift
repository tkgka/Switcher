//
//  KeyMappingView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import SwiftUI

struct KeyMappingView: View {
    
    @ObservedObject private var model = KeyMapModel.shared
    @State private var toggles: [Bool] = Array(repeating: false, count: KeyMapModel.shared.mappedKeys.count)
    
    var body: some View {
        VStack {
            Header()
            List {
                ForEach(0 ..< model.mappedKeys.count, id: \.self) { index in
                    HStack{
                        Toggle(Texts.mappedKey(model.mappedKeys[index]), isOn: $toggles[index])
                    }
                }
            }
        }.frame(height: 300)
    }
    
    func appendDataToEventDict() {
        guard let newInputValue = model.newInputValue,
              let newReturnValue = model.newReturnValue,
              !model.mappedKeys.contains(.init(inputFlagAndKey: newInputValue, returnFlagAndKey: newReturnValue))
        else {
            return
        }
        let mappedKey: MappedKey = .init(inputFlagAndKey: newInputValue, returnFlagAndKey: newReturnValue)
        model.mappedKeys.append(mappedKey)
        model.newInputValue = nil
        model.newReturnValue = nil
        toggles = Array(repeating: false, count: model.mappedKeys.count)
    }
    
    func RemoveDataFromEventDict() {
        var removeValues = MappedKeys()
        (0 ..< model.mappedKeys.count).forEach({ index in
            guard toggles[index] else { return }
            removeValues.append(model.mappedKeys[index])
        })
        model.mappedKeys.removeAll(where: { removeValues.contains($0) })
        toggles = Array(repeating: false, count: model.mappedKeys.count)
    }
}


// MARK: - Header

private extension KeyMappingView {
    
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
                    if let newValue = model.newInputValue {
                        return Texts.newValue(newValue)
                    }
                    guard model.isAddingNewInputValue else {
                        return Texts.pressToSelectMappingKey
                    }
                    return Texts.waiting
                }
                Text(text)
                    .font(.system(size: Metric.fontSize, weight: .semibold))
                    .onTapGesture {
                        model.newInputValue = nil
                        model.isAddingNewInputValue.toggle()
                    }
            }.frame(width: Metric.defaultWidth, alignment: .center)
            VStack {
                Text("->")
            }.frame(width: 20, alignment: .center)
            VStack {
                var text: String {
                    if let newValue = model.newReturnValue {
                        return Texts.newValue(newValue)
                    }
                    guard model.isAddingNewReturnValue else {
                        return Texts.pressToSelectMappingKey
                    }
                    return Texts.waiting
                }
                Text(text)
                    .font(.system(size: Metric.fontSize, weight: .semibold))
                    .onTapGesture {
                        model.newReturnValue = nil
                        model.isAddingNewReturnValue.toggle()
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

private extension KeyMappingView {
    
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
        static let pressToSelectMappingKey = "PressToSelectMappingKey".localized
        static let waiting = "waiting".localized
        
        static func mappedKey(_ value: MappedKey) -> String {
            return "\(FlagMap.arrayFlags(flagNum: value.inputFlagAndKey.flag).sortedString) \(value.inputFlagAndKey.key.string) -> \(FlagMap.arrayFlags(flagNum: value.returnFlagAndKey.flag).sortedString) \(value.returnFlagAndKey.key.string)"
        }
        static func newValue(_ value: FlagAndKey) -> String {
            return "\(FlagMap.arrayFlags(flagNum: value.flag).sortedString) \(value.key.string)"
        }
    }
}
