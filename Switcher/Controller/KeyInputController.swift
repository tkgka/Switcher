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
        if ObservedKeyVals.PressedKey == "Waiting"{
            let FlagString = GetFlags(Val: event.modifierFlags.rawValue + 256)
            KeyMaps[MouseBtnNum(val: event.buttonNumber)] != nil ? (ObservedKeyVals.PressedKey = FlagString + KeyMaps[MouseBtnNum(val: event.buttonNumber)]!) : (ObservedKeyVals.PressedKey = "\(FlagString) \(String(MouseBtnNum(val: event.buttonNumber)))")
            ObservedKeyVals.PressedKeyEvent = PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)
            return nil
        }
        
        if ObservedKeyVals.EventDict.keys.contains(PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)) && ObservedToggles.KeyMap == true {
            let value:EventStruct = ObservedKeyVals.EventDict[PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)]!
            let ReturnValue = CreateNSEvent(event: event, KeyCode:value.keys, Flag: value.FlagNum)
            return ReturnValue.cgEvent
        }
        else { return cgEvent }
    }
    
    if(event.type == .keyUp || event.type == .keyDown) {

        let AlertKeyString:String = "\(GetFlags(Val: event.modifierFlags.rawValue, GetDirection: false))\(KeyMaps[event.keyCode] ?? String(event.keyCode))"
        let FlagString = GetFlags(Val: event.modifierFlags.rawValue)
        let checkEventDict = ObservedKeyVals.EventDict[PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)]
        
        if ObservedAlertVals.PressedKey == "Waiting" {
            ObservedAlertVals.PressedKey = AlertKeyString
            return nil
        }
        
        if ObservedKeyVals.PressedKey == "Waiting" {
            
            KeyMaps[event.keyCode] != nil ? (ObservedKeyVals.PressedKey = FlagString + KeyMaps[event.keyCode]!) : (ObservedKeyVals.PressedKey = FlagString + String(event.keyCode))
            ObservedKeyVals.PressedKeyEvent = PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)
            
            return nil
        }
        if ObservedKeyVals.ReturnKey == "Waiting" {
            
            KeyMaps[event.keyCode] != nil ? (ObservedKeyVals.ReturnKey = KeyMaps[event.keyCode]! + FlagString) : (ObservedKeyVals.ReturnKey = FlagString + String(event.keyCode))
            ObservedKeyVals.ReturnKeyEvent = EventStruct(keys: event.keyCode, FlagNum: event.modifierFlags.rawValue)
            
            return nil
        }
        
        
        if ((event.type == .keyDown && ObservedToggles.CMDQ == true) && // key down && CMDQ IS Set to Use
            (ObservedAlertVals.PressedKeyEvent.contains(AlertKeyString) && // Pressed Key is setted on Alertkeys
             ((ObservedToggles.KeyMap == false) ||  // keyMapping is setted false
              (ObservedToggles.KeyMap == true && checkEventDict == nil)) )) { // keyMapping is on use but key Alert key doesn't mapped
            
            if ((ObservedAlertVals.AlertList.count <= 0) || (checkApplicationIsActive(Applications: Array(ObservedAlertVals.AlertList.keys)))){
                return IsAlertOn(cgEvent: cgEvent, Text:AlertKeyString)
            }
            return cgEvent
            
        }
        else  if ((event.type == .keyDown && ObservedToggles.CMDQ == true) && // key down && CMDQ IS Set to Use
                  ObservedToggles.KeyMap == true && checkEventDict != nil && // check toggle is true and Event dict exception
                  ObservedAlertVals.PressedKeyEvent.contains("\(GetFlags(Val: checkEventDict!.FlagNum, GetDirection: false))\(KeyMaps[checkEventDict!.keys] ?? String(event.keyCode))")) { // pressed key that mapped to Alert Key
            
            let CGEventVal:CGEvent = CreateNSEvent(event:NSEvent(cgEvent: cgEvent)!, KeyCode:checkEventDict!.keys, Flag:checkEventDict!.FlagNum).cgEvent!
            
            if ((ObservedAlertVals.AlertList.count <= 0) || (checkApplicationIsActive(Applications: Array(ObservedAlertVals.AlertList.keys)))){ // 실행중인 application이 있는 경우 또는 특정 application 만 알림을 띄워주도록 설정한 경우
                return IsAlertOn(cgEvent: CGEventVal, Text:"\(GetFlags(Val: checkEventDict!.FlagNum, GetDirection: false))\(KeyMaps[checkEventDict!.keys] ?? String(event.keyCode))")
            }
            return CGEventVal
        }
        
        else if ObservedKeyVals.EventDict.keys.contains(PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)) && ObservedToggles.KeyMap == true { // EventDict 에 입력된 키 값이 있는지 확인, keyMap toggle true 인지 확인
            let value:EventStruct = ObservedKeyVals.EventDict[PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)]!
            let ReturnValue = CreateNSEvent(event: event, KeyCode:value.keys, Flag: value.FlagNum) // mapping 된 키 값 리턴
            return ReturnValue.cgEvent
        }
        
        else { return cgEvent }
        
    } else  if event.type == .scrollWheel && ObservedToggles.MouseWheel == true {
        AlertIsOn = false
        if (event.momentumPhase.rawValue == 0 && event.phase.rawValue == 0) {
            return CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.pixel, wheelCount: 1, wheel1: Int32(event.deltaY * -10), wheel2: 0, wheel3: 0)
        } else {
            return cgEvent
        }
    } else {
        event.type != .keyUp ? AlertIsOn = false : nil
        return cgEvent
    }
}

