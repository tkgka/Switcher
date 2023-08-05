//
//  KeyInputController.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import SwiftUI

struct KeyInputController {
    
    static func handle(event: NSEvent, cgEvent: CGEvent, wrapper: Wrapper, proxy: CGEventTapProxy) -> CGEvent? {
        guard event.type == .keyDown || event.type == .keyUp,
              MenuModel.shared.preventKeyPressByMistake
        else {
            return cgEvent
        }
        
        let result = preventKeyPressByMistake(event: event)
        return result
    }
}


// MARK: - Prevent Key Press By Mistake


private extension KeyInputController {
    
    static func preventKeyPressByMistake(event: NSEvent) -> CGEvent? {
        guard event.keyCode == lastPressedKeyEvent?.keyCode,
              event.modifierFlags.rawValue == lastPressedKeyEvent?.modifierFlags.rawValue
        else {
            if event.type == .keyDown {
                lastPressedKeyEvent = event
            }
            alertWindow?.close()
            let flagText = String(
                FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue).sorted(by: {$0.rawValue > $1.rawValue})
                    .flatMap { flag in
                        flag.string
                    }
            )
            alertWindow = AlertView(
                alertText: "\(flagText) \(KeyMap(rawValue: event.keyCode)?.string ?? "")"
            ).showViewOnNewWindowInSpecificTime(during: Constant.alertTimeout)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.alertTimeout) {
                if lastPressedKeyEvent == event {
                    lastPressedKeyEvent = nil
                }
            }
            return nil
        }
        
        if event.type == .keyDown {
            lastPressedKeyEvent = nil
        }
        return event.cgEvent
    }
    
    static var lastPressedKeyEvent: NSEvent?
    static var alertWindow: NSWindow?
}


// MARK: - Constant

private extension KeyInputController {
    
    enum Constant {
        static let alertTimeout = 1.5
    }
}
