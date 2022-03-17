//
//  popupController.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/21.
//

import SwiftUI
import AlertPopup
extension View {
    //    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        weak var win = NSWindow(contentViewController: NSHostingController(rootView: self))
        win!.title = title
        win!.makeKeyAndOrderFront(sender)
        win!.orderFrontRegardless()
        return win!
    }
}
func AlertPopupTimeout(){
    DispatchQueue.main.asyncAfter(deadline: .now() + DefaultTimeout) {
        currentWindow?.close()
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

func CreateNSEvent(event:NSEvent, KeyCode:UInt16, Flag:UInt) -> NSEvent{
    weak var Event = NSEvent.keyEvent(with: event.type, location: event.locationInWindow, modifierFlags: .init(rawValue: Flag), timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: event.isARepeat, keyCode: KeyCode)
    return Event!
}



weak var currentWindow:NSWindow? = nil

func IsAlertOn(cgEvent:CGEvent) -> CGEvent?{
    if (AlertIsOn == true) {
        AlertIsOn = false
        return cgEvent
    }else{
        if currentWindow != nil{
            currentWindow!.close()
            currentWindow = nil
        }
        currentWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Enter 􀆔q again \nto shutdown app", Timer: 1.5, ImageColor: Color("ImageColor"), FontColor: Color("FontColor"))
        AlertPopupTimeout()
        AlertIsOn = true
        return nil
    }
}


func SetKeyMapValue(){
    if (UserDefaults.standard.value(forKey:"EventDict")) != nil{
        ObservedObjects.EventDict = (try? JSONDecoder().decode([String:EventStruct].self, from: (UserDefaults.standard.value(forKey:"EventDict")) as! Data))!
    }
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




class FuncNumToText {
    
    var ReturnVal:[String] = []
    
    var FlagList:[String:Int] = ["􀆍":0, "􀆕":0, "􀆔":0, "􀆝":0]
    func FlagNumToString(Val:Int){
        if FlagMaps[Val] != nil {
            FlagList[FlagMaps[Val]!] != nil ? (FlagList[FlagMaps[Val]!]! += 1) : nil
            ReturnVal.append(FlagMaps[Val]!)
        }
        else if Val > 8388864 {
            ReturnVal.append("FN")
            return FlagNumToString(Val: Val - 8388864 + 256)
        }
        else if Val > 1048840 && Val < 8388864 {
            ReturnVal.append(FlagMaps[1048840]!)
            FlagList[FlagMaps[1048840]!]! += 1
            return FlagNumToString(Val: Val - 1048840 + 256)
        }
        else if Val > 524576 && Val < 1048840 {
            ReturnVal.append(FlagMaps[524576]!)
            FlagList[FlagMaps[524576]!]! += 1
            return FlagNumToString(Val: Val - 524576 + 256)
        }
        else if Val > 262401 && Val < 524640 {
            ReturnVal.append(FlagMaps[262401]!)
            FlagList[FlagMaps[262401]!]! += 1
            return FlagNumToString(Val: Val - 262401 + 256)
        }
        else if Val > 131330 && Val < 270592 {
            ReturnVal.append(FlagMaps[131330]!)
            FlagList[FlagMaps[131330]!]! += 1
            return FlagNumToString(Val: Val - 131330 + 256)
        }
        else if Val > 65792 {
            ReturnVal.append(FlagMaps[65792]!)
            return FlagNumToString(Val: Val - 65792 + 256)
        }
        else {
            FlagLoc(Val: Val-256)
        }
        print(FlagList)
        let TmpList:[String] = Array(FlagList.keys).filter{ FlagList[$0]! > 0 }
        for i in TmpList{
            let val:String = i
            if ReturnVal.firstIndex(of: val) != nil {
                var KeyLoc:String = ""
//                    FlagList[i]! == 1 ? (KeyLoc = "R") : (KeyLoc = "B")
                FlagList[i]! == 1 ? (KeyLoc = "L") : nil
                FlagList[i]! == 2 ? (KeyLoc = "R") : nil
                FlagList[i]! == 3 ? (KeyLoc = "B") : nil
                ReturnVal[ReturnVal.firstIndex(of: val)!] = KeyLoc+i
            }
        }
    }
    func FlagLoc(Val:Int){
        if Val >= 8191 {
            FlagList["􀆍"]! += 1
            FlagLoc(Val: Val-8191)
        }else if Val >= 32 {
            FlagList["􀆕"]! += 1
            FlagLoc(Val: Val-32)
        }else if Val >= 8{
            FlagList["􀆔"]! += 1
            FlagLoc(Val: Val-8)
        }else if Val >= 2{
            FlagList["􀆝"]! += 1
            FlagLoc(Val: Val-2)
        }else if Val == 1{
            FlagList["􀆍"]! += 1
        }
    }
    
}
