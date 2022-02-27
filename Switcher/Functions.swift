//
//  popupController.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/21.
//

import SwiftUI
import AlertPopup
extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let win = self.setWindow()
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
}
func AlertPopupTimeout(){
    DispatchQueue.main.asyncAfter(deadline: .now() + DefaultTimeout) {
        AlertIsOn = false
    }
}

func CreateEvent(event:NSEvent, cgEvent:CGEvent, dic:[UInt16 : [UInt16]], index:Int, keyDown:Bool) -> CGEvent{
    let Event = CGEvent(keyboardEventSource: nil, virtualKey: dic[UInt16(event.keyCode)]![index], keyDown: keyDown);
    Event?.timestamp = cgEvent.timestamp
        FlagMaps["Fn"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskSecondaryFn) : nil
        FlagMaps["Any"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = cgEvent.flags) : nil
        FlagMaps["􀆝"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskShift) : nil
        FlagMaps["􀆍"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskControl) : nil
        FlagMaps["􀆕"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskAlternate) : nil
        FlagMaps["􀆔"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskCommand) : nil
    return Event!
}

func IsAlertOn(cgEvent:CGEvent) -> CGEvent?{
    if (AlertIsOn == true) {
        AlertIsOn = false
        return cgEvent
    }else{
        if currentWindow != nil{
            closeWindow(window: currentWindow!)
            currentWindow = nil
        }
        currentWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Enter 􀆔q again \nto shutdown app", Timer: 1.5, ImageColor: Color("ImageColor"), FontColor: Color("FontColor"))
        AlertPopupTimeout()
        AlertIsOn = true
        return nil
    }
}


func SetKeyMapValue(){
    IsflagsChanged.removeAll()
    KeyDict.removeAll()
    for (index, value) in ListOfKeyMap.enumerated().reversed(){
        if((value[0] == "" || value[2] == "") || (KeyDict[KeyMaps[value[0]]!] != nil)){
            if FlagMaps[value[1]]![0] == 0x00 { // if Keys Flag == Any
                ListOfKeyMap.removeAll(where: {$0[0] == value[0] && $0 != value})
                IsChecked.remove(at: index)
            }
            else if (FlagMaps[value[1]]![0] == KeyDict[KeyMaps[value[0]]!]![0] || KeyDict[KeyMaps[value[0]]!]![0] == 0x00){
                ListOfKeyMap.remove(at: index)
                IsChecked.remove(at: index)
            }
        }else{
            KeyDict[KeyMaps[value[0]]!] = [FlagMaps[value[1]]![0],FlagMaps[value[1]]![1],KeyMaps[value[2]]!,KeyMaps[value[3]]!] // (0,1): keysFlag, 2: MappedKeyVal, 3: MappedKeysFlag
        }
    }
    if IsChecked.count != ListOfKeyMap.count {
        IsChecked.removeAll()
        for _ in (1...ListOfKeyMap.count){
            IsChecked.append(false)
        }
        ListOfKeyMap = Array(Set(ListOfKeyMap))
    }
}
