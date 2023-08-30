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
        
        guard event.type == .keyDown || event.type == .keyUp || event.type == .otherMouseDown || event.type == .otherMouseUp else {
            return cgEvent
        }
        
        if event.type == .keyDown || event.type == .keyUp {
            guard !PreventKeyModel.shared.isAddingNewValue else {
                setUpNewPreventKeyValue(event: event)
                return nil
            }
            
            guard !KeyMapModel.shared.isAddingNewReturnValue else {
                setUpMappingKeyValue(event: event)
                return nil
            }
        }
        guard !KeyMapModel.shared.isAddingNewInputValue else {
            setUpMappingKeyValue(event: event)
            return nil
        }
        let currentlyActiveApplicationController: CurrentlyActiveApplicationControllerType = CurrentlyActiveApplicationController()
        if let applicationIdentifier = currentlyActiveApplicationController.applicationsDataContainFfrontmostApplication(applications: ApplicationModel.shared.applications) {
            guard let applicationData = ApplicationModel.shared.applications.first(where: { $0.identifier == applicationIdentifier }) else {
                return returnResultCGEvent(_event: event, _cgEvent: cgEvent, preventedKeys: PreventKeyModel.shared.preventedKeys, mappedKeys: KeyMapModel.shared.mappedKeys)
            }
            return returnResultCGEvent(_event: event, _cgEvent: cgEvent, preventedKeys: applicationData.preventedKeys, mappedKeys: applicationData.mappedKeys)
        }
        
        
        return returnResultCGEvent(_event: event, _cgEvent: cgEvent, preventedKeys: PreventKeyModel.shared.preventedKeys, mappedKeys: KeyMapModel.shared.mappedKeys)
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
        let isMouseKey = event.type == .otherMouseDown || event.type == .otherMouseUp
        guard let key = isMouseKey ? KeyMap(rawValue: event.uInt16ButtonNumber) : KeyMap(rawValue: event.keyCode)
        else {
            PreventKeyModel.shared.isAddingNewValue = false
            return
        }
        PreventKeyModel.shared.newValue = .init(flags: FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue + (isMouseKey ? 256 : 0)), key: key)
        PreventKeyModel.shared.isAddingNewValue = false
    }
    
    static func setUpMappingKeyValue(event: NSEvent) {
        let isMouseKey = event.type == .otherMouseDown || event.type == .otherMouseUp
        let model = KeyMapModel.shared
        guard let key = isMouseKey ? KeyMap(rawValue: event.uInt16ButtonNumber) : KeyMap(rawValue: event.keyCode)
        else {
            model.isAddingNewInputValue = false
            model.isAddingNewReturnValue = false
            return
        }
        model.isAddingNewInputValue
        ? (model.newInputValue = .init(flag: event.modifierFlags.rawValue + (isMouseKey ? 256 : 0), key: key))
        : (model.newReturnValue = .init(flag: event.modifierFlags.rawValue + (isMouseKey ? 256 : 0), key: key))
        
        model.isAddingNewInputValue = false
        model.isAddingNewReturnValue = false
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


// MARK: - Core

private extension KeyInputController {
    
    static func returnResultCGEvent(_event: NSEvent, _cgEvent: CGEvent, preventedKeys: PreventedKeys, mappedKeys: MappedKeys) -> CGEvent? {
        let isMouseKey = _event.type == .otherMouseDown || _event.type == .otherMouseUp
        var event = _event
        var cgEvent = _cgEvent
        
        if MenuModel.shared.keyMap {
            if let newNSEvent = event.mappedKey(keys: mappedKeys, isMouseKey: isMouseKey) {
                event = newNSEvent
                cgEvent = newNSEvent.cgEvent ?? _cgEvent
            }
        }
        
        guard MenuModel.shared.preventKeyPressByMistake else {
            return cgEvent
        }
        
        let flags = FlagMap.arrayFlags(flagNum: event.modifierFlags.rawValue + (isMouseKey ? 256 : 0)).sorted
        if !isMouseKey {
            guard preventedKeys.contains(where: {$0.key.rawValue == event.keyCode && $0.flags.sorted == flags}) else {
                return cgEvent
            }
            let result = KeyInputController.preventKeyPressByMistake(event: event)
            return result
        }
        return cgEvent
    }
}


// MARK: - Constant

private extension KeyInputController {
    
    enum Constant {
        static let alertTimeout = 1.5
    }
}


extension NSEvent {
    
    var uInt16ButtonNumber: uint16 {
        UInt16(1000 + self.buttonNumber)
    }
}

