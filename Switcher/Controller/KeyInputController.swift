import Cocoa
import SwiftUI
import AlertPopup


class Wrapper {
    
    var state: State?
    
    class State {
        init(mouseDownEvent: CGEvent) {
            self.mouseDownEvent = mouseDownEvent
        }
        
        var mouseDownEvent: CGEvent
        var task: DispatchWorkItem!
        var isRight = false
        var mouseMoves: [CGPoint] = []
        
    }
}

func handle(event: NSEvent, cgEvent: CGEvent, wrapper: Wrapper, proxy: CGEventTapProxy) -> CGEvent? {
    if (event.type == .otherMouseUp || event.type == .otherMouseDown) {
        if observedKeyVal.pressedKey == "Waiting" {
            let flagString = getFlags(val: event.modifierFlags.rawValue + 256)
            keyMaps[MouseBtnNum(val: event.buttonNumber)] != nil
            ? (observedKeyVal.pressedKey = flagString + keyMaps[MouseBtnNum(val: event.buttonNumber)]!)
            : (observedKeyVal.pressedKey = "\(flagString) \(String(MouseBtnNum(val: event.buttonNumber)))")
            observedKeyVal.pressedKeyEvent = pressedKeyEventStringMaker(
                keycode: MouseBtnNum(val: event.buttonNumber),
                flag: event.modifierFlags.rawValue + 256
            )
            return nil
        }
        
        if observedKeyVal.EventDict.keys.contains(pressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), flag: event.modifierFlags.rawValue + 256)) && observedToggles.keyMap == true {
            let value:EventStruct = observedKeyVal.EventDict[pressedKeyEventStringMaker(
                keycode: MouseBtnNum(val: event.buttonNumber),
                flag: event.modifierFlags.rawValue + 256
            )]!
            let returnValue = createNSEvent(event: event, keyCode:value.keys, flag: value.flagNum)
            return returnValue.cgEvent
        }
        else { return cgEvent }
    }
    
    if(event.type == .keyUp || event.type == .keyDown) {
        
        let alertKeyString: String = "\(getFlags(val: event.modifierFlags.rawValue, getDirection: false))\(keyMaps[event.keyCode] ?? String(event.keyCode))"
        let flagString = getFlags(val: event.modifierFlags.rawValue)
        let checkEventDict = observedKeyVal.EventDict[pressedKeyEventStringMaker(
            keycode: event.keyCode,
            flag: event.modifierFlags.rawValue
        )]
        
        if observedAlertVal.pressedKey == "Waiting" {
            observedAlertVal.pressedKey = alertKeyString
            return nil
        }
        
        if observedKeyVal.pressedKey == "Waiting" {
            
            keyMaps[event.keyCode] != nil
            ? (observedKeyVal.pressedKey = flagString + keyMaps[event.keyCode]!)
            : (observedKeyVal.pressedKey = flagString + String(event.keyCode))
            observedKeyVal.pressedKeyEvent = pressedKeyEventStringMaker(
                keycode: event.keyCode,
                flag: event.modifierFlags.rawValue
            )
            
            return nil
        }
        if observedKeyVal.returnKey == "Waiting" {
            
            keyMaps[event.keyCode] != nil
            ? (observedKeyVal.returnKey = keyMaps[event.keyCode]! + flagString)
            : (observedKeyVal.returnKey = flagString + String(event.keyCode))
            observedKeyVal.returnKeyEvent = EventStruct(keys: event.keyCode, flagNum: event.modifierFlags.rawValue)
            
            return nil
        }
        
        
        if ((event.type == .keyDown && observedToggles.alertKey == true) && // key down && CMDQ IS Set to Use
            (observedAlertVal.pressedKeyEvent.contains(alertKeyString) && // Pressed Key is setted on Alertkeys
             ((observedToggles.keyMap == false) ||  // keyMapping is setted false
              (observedToggles.keyMap == true && checkEventDict == nil)) )) { // keyMapping is on use but key Alert key doesn't mapped
            
            if ((observedAlertVal.alertList.count <= 0) || (checkApplicationIsActive(Applications: Array(observedAlertVal.alertList.keys)))) {
                return isAlertOn(cgEvent: cgEvent, text:alertKeyString)
            }
            return cgEvent
            
        }
        else  if ((event.type == .keyDown && observedToggles.alertKey == true) && // key down && CMDQ IS Set to Use
                  observedToggles.keyMap == true && checkEventDict != nil && // check toggle is true and Event dict exception
                  observedAlertVal.pressedKeyEvent.contains(
                    "\(getFlags(val: checkEventDict!.flagNum, getDirection: false))\(keyMaps[checkEventDict!.keys] ?? String(event.keyCode))")
        ) { // pressed key that mapped to Alert Key
            let cgEventVal: CGEvent = createNSEvent(event:NSEvent(cgEvent: cgEvent)!, keyCode:checkEventDict!.keys, flag:checkEventDict!.flagNum).cgEvent!
            
            if (
                (observedAlertVal.alertList.count <= 0)
                || (checkApplicationIsActive(Applications: Array(observedAlertVal.alertList.keys)))
            ) { // 실행중인 application이 있는 경우 또는 특정 application 만 알림을 띄워주도록 설정한 경우
                return isAlertOn(
                    cgEvent: cgEventVal, text:"\(getFlags(val: checkEventDict!.flagNum, getDirection: false))\(keyMaps[checkEventDict!.keys] ?? String(event.keyCode))"
                )
            }
            return cgEventVal
        }
        
        else if observedKeyVal.EventDict.keys.contains(
            pressedKeyEventStringMaker(
                keycode: event.keyCode,
                flag: event.modifierFlags.rawValue
            )
        ) && observedToggles.keyMap == true { // EventDict 에 입력된 키 값이 있는지 확인, keyMap toggle true 인지 확인
            let value:EventStruct = observedKeyVal.EventDict[pressedKeyEventStringMaker(
                keycode: event.keyCode,
                flag: event.modifierFlags.rawValue
            )]!
            let returnValue = createNSEvent(event: event, keyCode:value.keys, flag: value.flagNum) // mapping 된 키 값 리턴
            return returnValue.cgEvent
        }
        
        else { return cgEvent }
        
    } else  if event.type == .scrollWheel && observedToggles.mouseWheel == true {
        alertIsOn = false
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
            return cgEvent
        }
    } else {
        event.type != .keyUp ? alertIsOn = false : nil
        return cgEvent
    }
}

