//
//  PreventKeySelectView.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import SwiftUI

struct PreventKeySelectView: View {
    
    @ObservedObject private var model = PreventKeyModel.shared
    @ObservedObject private var applicationModel = ApplicationModel.shared
    @State private var toggles: [Bool] = Array(repeating: false, count: PreventKeyModel.shared.preventedKeys.count)
    @State private var currentlySelectedApplication: ApplicationData?
    @State private var window: NSWindow?
    var body: some View {
        VStack(spacing: 0.0) {
            Header()
            ApplicationSelector()
            List {
                if let currentlySelectedApplication,
                   let selectedApplication =  applicationModel.applications.first(where: {$0.identifier == currentlySelectedApplication.identifier}) {
                    ForEach(0 ..< selectedApplication.preventedKeys.count, id: \.self) { index in
                        HStack{
                            Toggle(Texts.newValue(.init(flags: selectedApplication.preventedKeys[index].flags, key: selectedApplication.preventedKeys[index].key)), isOn: $toggles[index])
                        }
                    }
                } else {
                    ForEach(0 ..< model.preventedKeys.count, id: \.self) { index in
                        HStack{
                            Toggle(Texts.newValue(.init(flags: model.preventedKeys[index].flags, key: model.preventedKeys[index].key)), isOn: $toggles[index])
                        }
                    }
                }
            }
            .background(Color("BGColor"))
            .scrollContentBackground(.hidden)
        }.frame(height: 300)
            .onChange(of: currentlySelectedApplication) { newValue in
                if let currentlySelectedApplication,
                   let selectedApplication =  applicationModel.applications.first(where: {$0.identifier == currentlySelectedApplication.identifier}) {
                    toggles = Array(repeating: false, count: selectedApplication.mappedKeys.count)
                }
                toggles = Array(repeating: false, count: model.preventedKeys.count)
            }
    }
    
    func appendDataToEventDict() {
        guard let newValue = model.newValue
        else {
            model.newValue = nil
            return
        }
        if let currentlySelectedApplication,
           var selectedApplication = applicationModel.applications.first(where: {$0.identifier == currentlySelectedApplication.identifier}) {
            guard !selectedApplication.preventedKeys.contains(newValue) else {
                model.newValue = nil
                return
            }
            applicationModel.applications.removeAll(where: {$0 == selectedApplication})
            selectedApplication.preventedKeys.append(newValue)
            applicationModel.applications.append(selectedApplication)
            model.newValue = nil
            toggles = Array(repeating: false, count: selectedApplication.preventedKeys.count)
            return
        }
        guard !model.preventedKeys.contains(newValue) else {
            model.newValue = nil
            return
        }
        model.preventedKeys.append(newValue)
        model.newValue = nil
        toggles = Array(repeating: false, count: model.preventedKeys.count)
    }
    
    func RemoveDataFromEventDict() {
        
        if let currentlySelectedApplication,
           var selectedApplication = applicationModel.applications.first(where: {$0.identifier == currentlySelectedApplication.identifier}) {
            var removeValues = PreventedKeys()
            (0 ..< selectedApplication.preventedKeys.count).forEach({ index in
                guard toggles[index] else { return }
                removeValues.append(selectedApplication.preventedKeys[index])
            })
            applicationModel.applications.removeAll(where: {$0 == selectedApplication})
            selectedApplication.preventedKeys.removeAll(where: { removeValues.contains($0) })
            applicationModel.applications.append(selectedApplication)
            toggles = Array(repeating: false, count: selectedApplication.preventedKeys.count)
            return
        }
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
        Spacer(minLength: Metric.largeSpacing)
    }
}


// MARK: - Applications

private extension PreventKeySelectView {
    
    @ViewBuilder
    func ApplicationSelector() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0.0) {
                if let icon = NSImage(systemSymbolName: "ellipsis.circle", accessibilityDescription: nil) {
                    Image(nsImage: icon)
                        .font(.largeTitle)
                        .frame(width: 50, height: 30)
                        .background(currentlySelectedApplication == nil ? Color("BGColor") : Color.clear)
                        .onTapGesture {
                            currentlySelectedApplication = nil
                            toggles = Array(repeating: false, count: model.preventedKeys.count)
                        }
                }
                ForEach(applicationModel.applications, id: \.self) { application in
                    if let iconData = application.imageData,
                       let icon = NSImage(data: iconData) {
                        Image(nsImage: icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                            .background(application.identifier == currentlySelectedApplication?.identifier ? Color("BGColor") : Color.clear)
                            .onTapGesture {
                                currentlySelectedApplication = application
                                toggles = Array(repeating: false, count: application.preventedKeys.count)
                            }
                    }
                }
                if let icon = NSImage(systemSymbolName: "plus.circle", accessibilityDescription: nil) {
                    Image(nsImage: icon)
                        .font(.largeTitle)
                        .frame(width: 50, height: 30)
                        .background(Color.clear)
                        .onTapGesture {
                            window?.close()
                            window = ApplicationsAddView().openInWindow(title: "Switcher", sender: self)
                        }
                }
            }
        }
    }
}


// MARK: - Constant

private extension PreventKeySelectView {
    
    enum Metric {
        static let defaultWidth = 180.0
        static let minimumSpacing = 3.0
        static let largeSpacing = 15.0
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
