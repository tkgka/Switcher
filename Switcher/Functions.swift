//
//  popupController.swift
//  Switcher
//
//  Created by κΉμν on 2022/01/21.
//

import SwiftUI
import AlertPopup


extension View {
    //    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let win = NSWindow(contentViewController: NSHostingController(rootView: self))
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
}

func AlertPopupTimeout(){
    DispatchQueue.main.asyncAfter(deadline: .now() + DefaultTimeout) {
        currentWindow?.close()
        AlertIsOn = false
    }
}


func CreateNSEvent(event:NSEvent, KeyCode:UInt16, Flag:UInt) -> NSEvent{
    if (event.type.rawValue == 25 || event.type.rawValue == 26) { // event type != keyDown || event type != keyup
        weak var Event = NSEvent.keyEvent(with: .init(rawValue: event.type.rawValue - 15)!, location: event.locationInWindow, modifierFlags: .init(rawValue: Flag), timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: false, keyCode: KeyCode)
        return Event!
    }
    weak var Event = NSEvent.keyEvent(with: event.type, location: event.locationInWindow, modifierFlags: .init(rawValue: Flag), timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: event.isARepeat, keyCode: KeyCode)
    return Event!
}
//event type, isARepeat


weak var currentWindow:NSWindow? = nil

func IsAlertOn(cgEvent:CGEvent, Text:String) -> CGEvent?{
    if (AlertIsOn == true) {
        AlertIsOn = false
        //        return CreateNSEvent(event:NSEvent(cgEvent: cgEvent)!, KeyCode:12, Flag:1048840).cgEvent
        return cgEvent
    }else{
        if currentWindow != nil{
            currentWindow!.close()
            currentWindow = nil
        }
        currentWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Press \(Text) again \nto execute", Timer: 1.5, ImageColor: Color("ImageColor"), FontColor: Color("FontColor"))
        AlertPopupTimeout()
        AlertIsOn = true
        return nil
    }
}
