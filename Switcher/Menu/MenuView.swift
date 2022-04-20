//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//
// UI Design from " https://github.com/mik3sw/OneClick"

import SwiftUI
struct MenuView: View {
    @AppStorage("CMDQ") var CMDQToggle: Bool = UserDefaults.standard.bool(forKey: "CMDQ")
    @AppStorage("MouseWheel") var MouseWheelToggle: Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
    @AppStorage("KeyMap") var KeyMapToggle: Bool = UserDefaults.standard.bool(forKey: "KeyMap")
    
    var body: some View {
        VStack( alignment: .leading, spacing: 0){
            
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
                spacing: 0){
                    Image(systemName: "command")
                        .padding(.top, 15.0)
                        .padding(.leading, 15.0)
                        .frame(width: 40, alignment: .leading)
                        
                    Text("Command + q")
                        .fontWeight(.medium)
                        .padding(.top, 15.0)
                        .frame(width: 200, alignment: .leading)
                        
                    
                    if #available(macOS 11.0, *) {
                        Toggle("", isOn: $CMDQToggle)
                            .toggleStyle(.switch)
                            .frame(alignment: .leading)
                            .padding(.top, 15.0)
                    } else {
                        // Fallback on earlier versions
                    }
                }.onChange(of: CMDQToggle) { CMDQToggle in
                    CMDQ = CMDQToggle
                }
            Text("press command + q twice to shutdown App")
                .font(Font.system(size: 12.0))
                .fontWeight(.light)
                .padding(.leading, 15.0)
                .padding(.top, 15.0)
                .frame(alignment: .leading)
                .padding(.bottom, 15.0)
                }
                
                Divider()
                    .padding(.horizontal, 10.0)
                    .frame(width: 300)
            
            Group{
                HStack(
                    spacing: 0){
                        Image(systemName: "magicmouse")
                            .padding(.top, 15.0)
                            .padding(.leading, 15.0)
                            .frame(width: 40, alignment: .leading)
                            
                        Text("Mouse Wheel")
                            .fontWeight(.medium)
                            .padding(.top, 15.0)
                            .frame(width: 200, alignment: .leading)
                            
                        
                        if #available(macOS 11.0, *) {
                            Toggle("", isOn: $MouseWheelToggle)
                                .toggleStyle(.switch)
                                .frame(alignment: .leading)
                                .padding(.top, 15.0)
                        } else {
                            // Fallback on earlier versions
                        }
                    }.onChange(of: MouseWheelToggle) { MouseWheelToggle in
                        MouseWheel = MouseWheelToggle
                    }
                Text("Change Mouse Wheel Direction")
                    .font(Font.system(size: 12.0))
                    .fontWeight(.light)
                    .padding(.leading, 15.0)
                    .padding(.top, 15.0)
                    .frame(alignment: .leading)
                    .padding(.bottom, 15.0)
                    }
            Divider()
                .padding(.horizontal, 10.0)
                .frame(width: 300)
            
            Group {
            HStack(
                spacing: 0){
                    Image(systemName: "keyboard")
                        .padding(.top, 15.0)
                        .padding(.leading, 15.0)
                        .frame(width: 40, alignment: .leading)
                        
                    Text("Key Mapper")
                        .fontWeight(.medium)
                        .padding(.top, 15.0)
                        .frame(width: 200, alignment: .leading)
                        
                    
                    if #available(macOS 11.0, *) {
                        Toggle("", isOn: $KeyMapToggle)
                            .toggleStyle(.switch)
                            .frame(alignment: .leading)
                            .padding(.top, 15.0)
                    } else {
                        // Fallback on earlier versions
                    }
                }.onChange(of: KeyMapToggle) { CMDQToggle in
                    KeyMap = KeyMapToggle
                }
            HStack{
            Text("Mapping key input and output")
                    .font(Font.system(size: 12.0))
                    .fontWeight(.light)
                    .padding(.leading, 15.0)
                    .padding(.top, 15.0)
                    .frame(alignment: .leading)
                    .padding(.bottom, 15.0)
            Text("Open")
                    .foregroundColor(Color.blue)
                    .font(Font.system(size: 12.0))
                    .fontWeight(.bold)
                    .padding(.leading, 15.0)
                    .padding(.top, 15.0)
                    .frame(alignment: .leading)
                    .padding(.bottom, 15.0)
                    .onTapGesture{
                        KeyMapWindow == nil ? (KeyMapWindow = MainKeyMapView().openInWindow(title: "KeyMap", sender: self)) : KeyMapWindow?.orderFrontRegardless()
                    }
                }
                }
                
                Divider()
                    .padding(.horizontal, 10.0)
                    .frame(width: 300)
            
            }
            
            
            HStack{
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
            
            
    }
        
    }


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}


//

