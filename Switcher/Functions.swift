//
//  popupController.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/21.
//

import SwiftUI
import AlertPopup
import ArrayFlags

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




func GetFlags(Val:UInt) -> String{
    let ArrayedFlag = GetArrayFlags(Val: Val).sorted()
    var FlagString:String = "["
    ArrayedFlag.forEach {
        if $0 < 10486016 {
            FlagString += FlagMaps[Int($0)]! + ","
        }
    }
    FlagString = FlagString.trimmingCharacters(in: [","]) + "]"
    return FlagString
}
