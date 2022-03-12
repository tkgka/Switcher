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

//func CreateEvent(event:NSEvent, cgEvent:CGEvent, dic:[UInt16 : [UInt16]], index:Int, keyDown:Bool) -> CGEvent{
//    let Event = CGEvent(keyboardEventSource: nil, virtualKey: dic[UInt16(event.keyCode)]![index], keyDown: keyDown);
//    Event?.timestamp = cgEvent.timestamp
//        FlagMaps["Fn"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskSecondaryFn) : nil
//        FlagMaps["Any"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = cgEvent.flags) : nil
//        FlagMaps["􀆝"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskShift) : nil
//        FlagMaps["􀆍"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskControl) : nil
//        FlagMaps["􀆕"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskAlternate) : nil
//        FlagMaps["􀆔"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskCommand) : nil
//    return Event!
//}

func CreateCGEvent(event:CGEventStruct, timestamp:UInt64, KeyDown:Bool) -> CGEvent{
    let Event = CGEvent(keyboardEventSource: nil, virtualKey: event.keys, keyDown: KeyDown);
    Event?.timestamp = timestamp
    Event?.flags = event.Flag
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
    print(UserDefaults.standard.dictionary(forKey: "CGEventDict"))
    if IsChecked.count != ListOfKeyMap.count {
        IsChecked.removeAll()
        for _ in (0...ListOfKeyMap.count){
            IsChecked.append(false)
        }
        ListOfKeyMap = Array(Set(ListOfKeyMap))
    }
}

func PressedKeyEventStringMaker(event:NSEvent) -> String{
    return String(event.keyCode) + "|" + String(event.modifierFlags.rawValue)
}




class FuncNumToTest {
    
    var ReturnVal:[String] = []
    func FlagNumToString(Val:Int){
        if FlagMaps[Val] != nil {
            ReturnVal.append(FlagMaps[Val]!)
//            print(FlagMaps.findKey(forValue: Val)!)
        }
        else if Val > 8388864 {
            ReturnVal.append("FN")
            return FlagNumToString(Val: Val - 8388864 + 256)
        }
        else if Val > 1048840 && Val < 8388864 {
            ReturnVal.append("􀆔")
            return FlagNumToString(Val: Val - 1048840 + 256)
        }
        else if Val > 524576 && Val < 1048848 {
            ReturnVal.append("􀆕")
            return FlagNumToString(Val: Val - 524576 + 256)
        }
        else if Val > 262401 && Val < 524640 {
            ReturnVal.append("􀆍")
            return FlagNumToString(Val: Val - 262401 + 256)
        }
        else if Val > 131330 && Val < 270592 {
            ReturnVal.append("􀆝")
            return FlagNumToString(Val: Val - 131330 + 256)
        }
    }
}
