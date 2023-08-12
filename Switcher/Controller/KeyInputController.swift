//
//  KeyInputController.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import SwiftUI

struct KeyInputController {
    
    static func handle(event: NSEvent, cgEvent: CGEvent, wrapper: Wrapper, proxy: CGEventTapProxy) -> CGEvent? {
        if event.type == .scrollWheel && MenuModel.shared.mouseWheel {
            guard let updatedCgEvent = changeMouseWheelDirection(with: event) else {
                return cgEvent
            }
            return updatedCgEvent
        }
        
        guard event.type == .keyDown || event.type == .keyUp else {
            return cgEvent
        }
        
        guard !PreventKeyModel.shared.isAddingNewValue else {
            setUpNewPreventKeyValue(event: event)
            return nil
        }
        
        guard MenuModel.shared.preventKeyPressByMistake else {
            return cgEvent
        }
        let flags = FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue).sorted
        guard PreventKeyModel.shared.preventedKeys.contains(where: {$0.key.rawValue == event.keyCode && $0.flags.sorted == flags}),
              CurrentlyActiveApplicationController().isKeyPreventApplicationsFfrontmostApplication(applications: PreventKeyModel.shared.preventedApplicationIdentifiers)
        else {
            return cgEvent
        }
        
        let result = preventKeyPressByMistake(event: event)
        return result
    }
}


// MARK: - Change Mouse Wheel Direction

private extension KeyInputController {
    static func changeMouseWheelDirection(with event: NSEvent) -> CGEvent? {
        if (event.momentumPhase.rawValue == 0 && event.phase.rawValue == 0) {
            return CGEvent(
                scrollWheelEvent2Source: nil,
                units: CGScrollEventUnit.pixel,
                wheelCount: 1,
                wheel1: Int32(event.deltaY * -10),
                wheel2: 0,
                wheel3: 0
            )
        } else {
            return nil
        }
    }
}


// MARK: - Prevent Key Press By Mistake


private extension KeyInputController {
    
    static func setUpNewPreventKeyValue(event: NSEvent) {
        guard let key = KeyMap(rawValue: event.keyCode)
        else {
            PreventKeyModel.shared.isAddingNewValue = false
            return
        }
        PreventKeyModel.shared.newValue = .init(flags: FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue), key: key)
        PreventKeyModel.shared.isAddingNewValue = false
    }
    
    static func preventKeyPressByMistake(event: NSEvent) -> CGEvent? {
        guard event.keyCode == lastPressedKeyEvent?.keyCode,
              event.modifierFlags.rawValue == lastPressedKeyEvent?.modifierFlags.rawValue
        else {
            if event.type == .keyDown {
                lastPressedKeyEvent = event
            }
            alertWindow?.close()
            let flagText = FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue).sortedString
            alertWindow = AlertView(
                alertText: String(format: "Alert_Text".localized, "\(flagText) \(KeyMap(rawValue: event.keyCode)?.string ?? "")")
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
