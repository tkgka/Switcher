//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//
// UI Design from " https://github.com/mik3sw/OneClick"

import SwiftUI
struct MenuView: View {
    
    @ObservedObject var ObserveToggles = ObservedToggles
    @State var WindowName:String? = nil
    
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
                        
                        Text(TextString.AlertText)
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                        
                        
                        if #available(macOS 11.0, *) {
                            Toggle("", isOn: $ObserveToggles.CMDQ)
                                .toggleStyle(.switch)
                                .frame(alignment: .leading)
                                .padding(.top, 15.0)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                HStack {
                    Text(TextString.AlertDesc)
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
//                            let Name = "AlertKey Setting"
//                            if (WindowName == nil || WindowName == Name) {
//                                KeyMapWindow == nil ? (KeyMapWindow = AlertKeySettingView().openInWindow(title: Name, sender: self)) : KeyMapWindow?.orderFrontRegardless()
//                            } else {
//                                KeyMapWindow?.close()
//                                KeyMapWindow = AlertKeySettingView().openInWindow(title: Name, sender: self)
//                            }
//                            WindowName = Name
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
                        
                        Text(TextString.MouseText)
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                        
                        
                        if #available(macOS 11.0, *) {
                            Toggle("", isOn: $ObserveToggles.MouseWheel)
                                .toggleStyle(.switch)
                                .frame(alignment: .leading)
                                .padding(.top, 15.0)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                Text(TextString.MouseDesc)
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
                        
                        
                        if #available(macOS 11.0, *) {
                            Toggle("", isOn: $ObserveToggles.KeyMap)
                                .toggleStyle(.switch)
                                .frame(alignment: .leading)
                                .padding(.top, 15.0)
                        } else {
                            // Fallback on earlier versions
                        }
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
//                            let Name = "KeyMap"
//                            if (WindowName == nil || WindowName == Name) {
//                                KeyMapWindow == nil ? (KeyMapWindow = MainKeyMapView().openInWindow(title: Name, sender: self)) : KeyMapWindow?.orderFrontRegardless()
//                            } else {
//                                KeyMapWindow?.close()
//                                KeyMapWindow = MainKeyMapView().openInWindow(title: Name, sender: self)
//                            }
//                            WindowName = Name
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
        
        .onChange(of: ObserveToggles.CMDQ) { CMDQ in
            UserDefaults.standard.set(CMDQ, forKey: "CMDQ")
        }
        .onChange(of: ObserveToggles.MouseWheel) { MouseWheel in
            UserDefaults.standard.set(MouseWheel, forKey: "MouseWheel")
        }
        .onChange(of: ObserveToggles.KeyMap) { KeyMap in
            UserDefaults.standard.set(KeyMap, forKey: "KeyMap")
        }
    }
    
}


private extension MenuView {
    
    enum TextString {
        static let AlertText:LocalizedStringKey = "Alert_Title"
        static let MouseText:LocalizedStringKey = "Mouse_Wheel_Title"
        static let keyMapText:LocalizedStringKey = "Key_Mapper_Title"
        static let AlertDesc:LocalizedStringKey = "Alert_Desc"
        static let MouseDesc:LocalizedStringKey = "Mouse_Wheel_Desc"
        static let keyMapDesc:LocalizedStringKey = "Key_Mapper_Desc"
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
