//
//  Function.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/21.
//

import SwiftUI
import AlertPopup

extension View {
    
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let win = NSWindow(contentViewController: NSHostingController(rootView: self))
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
}

func alertPopupTimeout() {
    DispatchQueue.main.asyncAfter(deadline: .now() + AlertView.defaultTimeout) {
        currentWindow?.close()
        alertIsOn = false
    }
}

func createNSEvent(event:NSEvent, keyCode:UInt16, flag:UInt) -> NSEvent {
    if (event.type.rawValue == 25 || event.type.rawValue == 26) { // event type != keyDown || event type != keyup
        weak var event = NSEvent.keyEvent(with: .init(rawValue: event.type.rawValue - 15)!, location: event.locationInWindow, modifierFlags: .init(rawValue: flag), timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: false, keyCode: keyCode)
        return event!
    }
    weak var event = NSEvent.keyEvent(with: event.type, location: event.locationInWindow, modifierFlags: .init(rawValue: flag), timestamp: event.timestamp, windowNumber: event.windowNumber, context: nil, characters: "", charactersIgnoringModifiers: "", isARepeat: event.isARepeat, keyCode: keyCode)
    return event!
}

weak var currentWindow:NSWindow? = nil

func isAlertOn(cgEvent:CGEvent, text:String) -> CGEvent? {
    if (alertIsOn == true) {
        alertIsOn = false
        return cgEvent
    }else{
        if currentWindow != nil{
            currentWindow!.close()
            currentWindow = nil
        }
        currentWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Press \(text) again \nto execute", Timer: 1.5, ImageColor: Color("ImageColor"), FontColor: Color("FontColor"))
        alertPopupTimeout()
        alertIsOn = true
        return nil
    }
}
