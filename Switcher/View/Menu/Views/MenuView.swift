//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//
// UI Design from " https://github.com/mik3sw/OneClick"

import SwiftUI

struct MenuView: View {
    
    @ObservedObject private var ObserveToggles = MenuModel.shared
    @State private var keyMapWindow: NSWindow?
    
    var body: some View {
        
        VStack( alignment: .leading, spacing: 0) {
            Text("Switcher")
                .font(Font.system(size: 15.0))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 15.0)
                .padding(.top, 15.0)
                .padding(.bottom, 15.0)
            
            Divider()
                .padding(.horizontal, 10.0)
                .frame(width: 300)
            
            Group {
                HStack(
                    spacing: 0) {
                        Image(systemName: "exclamationmark.triangle")
                            .padding(.top, 15.0)
                            .padding(.leading, 15.0)
                            .frame(width: 40, alignment: .leading)
                        
                        Text(TextString.alertText)
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                        
                        Toggle("", isOn: $ObserveToggles.preventKeyPressByMistake)
                            .toggleStyle(.switch)
                            .frame(alignment: .leading)
                            .padding(.top, 15.0)
                    }
                HStack {
                    Text(TextString.alertDesc)
                        .font(Font.system(size: 12.0))
                        .fontWeight(.light)
                        .padding(.leading, 15.0)
                        .padding(.top, 15.0)
                        .frame(width: 200, alignment: .leading)
                        .padding(.bottom, 15.0)
                    Text("Open")
                        .foregroundColor(Color.blue)
                        .font(Font.system(size: 12.0))
                        .fontWeight(.bold)
                        .padding(.leading, 15.0)
                        .padding(.top, 15.0)
                        .frame(alignment: .leading)
                        .padding(.bottom, 15.0)
                        .onTapGesture {
                            keyMapWindow?.close()
                            keyMapWindow = PreventKeySelectView().openInWindow(title: "Switcher", sender: self)
                            keyMapWindow?.orderFrontRegardless()
                        }
                }
            }
            Divider()
                .padding(.horizontal, 10.0)
                .frame(width: 300)
            
            Group {
                HStack(
                    spacing: 0){
                        Image(systemName: "magicmouse")
                            .padding(.top, 15.0)
                            .padding(.leading, 15.0)
                            .frame(width: 40, alignment: .leading)
                        
                        Text(TextString.mouseText)
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                        
                        Toggle("", isOn: $ObserveToggles.mouseWheel)
                            .toggleStyle(.switch)
                            .frame(alignment: .leading)
                            .padding(.top, 15.0)
                    }
                Text(TextString.mouseDesc)
                    .font(Font.system(size: 12.0))
                    .fontWeight(.light)
                    .padding(.leading, 15.0)
                    .padding(.top, 15.0)
                    .frame(width: 200, alignment: .leading)
                    .padding(.bottom, 15.0)
            }
            Divider()
                .padding(.horizontal, 10.0)
                .frame(width: 300)
            
            Group {
                HStack(
                    spacing: 0) {
                        Image(systemName: "keyboard")
                            .padding(.top, 15.0)
                            .padding(.leading, 15.0)
                            .frame(width: 40, alignment: .leading)
                        
                        Text(TextString.keyMapText)
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                        
                        Toggle("", isOn: $ObserveToggles.keyMap)
                            .toggleStyle(.switch)
                            .frame(alignment: .leading)
                            .padding(.top, 15.0)
                    }
                HStack {
                    Text(TextString.keyMapDesc)
                        .font(Font.system(size: 12.0))
                        .fontWeight(.light)
                        .padding(.leading, 15.0)
                        .padding(.top, 15.0)
                        .frame(width: 200, alignment: .leading)
                        .padding(.bottom, 15.0)
                    Text("Open")
                        .foregroundColor(Color.blue)
                        .font(Font.system(size: 12.0))
                        .fontWeight(.bold)
                        .padding(.leading, 15.0)
                        .padding(.top, 15.0)
                        .frame(alignment: .leading)
                        .padding(.bottom, 15.0)
                        .onTapGesture {
                            keyMapWindow?.close()
                            keyMapWindow = KeyMappingView().openInWindow(title: "Switcher", sender: self)
                            keyMapWindow?.orderFrontRegardless()
                        }
                }
            }
            Divider()
                .padding(.horizontal, 10.0)
                .frame(width: 300)
        }
        
        
        HStack {
            Link("\(Image(systemName: "link")) GitHub", destination: URL(string: "https://github.com/tkgka/Switcher")!)
                .buttonStyle(LinkButtonStyle())
                .padding(.leading, 15.0)
                .padding(.top, 15.0)
                .padding(.bottom, 10.0)
                .frame(width: 240, alignment: .leading)
            
            Button("Quit", action: {
                NSApplication.shared.terminate(self)
            })
            .padding(.top, 15.0)
            .padding(.bottom, 10.0)
            .frame(alignment: .leading)
        }
        
        .onChange(of: ObserveToggles.preventKeyPressByMistake) { alertKey in
            UserDefaults.standard.set(alertKey, forKey: "PreventKeyPressByMistake")
        }
        .onChange(of: ObserveToggles.mouseWheel) { MouseWheel in
            UserDefaults.standard.set(MouseWheel, forKey: "MouseWheel")
        }
        .onChange(of: ObserveToggles.keyMap) { KeyMap in
            UserDefaults.standard.set(KeyMap, forKey: "KeyMap")
        }
    }
    
}


private extension MenuView {
    
    enum TextString {
        static let alertText:LocalizedStringKey = "Alert_Title"
        static let mouseText:LocalizedStringKey = "Mouse_Wheel_Title"
        static let keyMapText:LocalizedStringKey = "Key_Mapper_Title"
        static let alertDesc:LocalizedStringKey = "Alert_Desc"
        static let mouseDesc:LocalizedStringKey = "Mouse_Wheel_Desc"
        static let keyMapDesc:LocalizedStringKey = "Key_Mapper_Desc"
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
