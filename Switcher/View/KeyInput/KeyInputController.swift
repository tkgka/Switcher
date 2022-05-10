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
        if ObservedObjects.PressedKey == "Waiting"{
            let FlagString = GetFlags(Val: event.modifierFlags.rawValue + 256)
            KeyMaps[MouseBtnNum(val: event.buttonNumber)] != nil ? (ObservedObjects.PressedKey = FlagString + KeyMaps[MouseBtnNum(val: event.buttonNumber)]!) : (ObservedObjects.PressedKey = "\(FlagString) \(String(MouseBtnNum(val: event.buttonNumber)))")
            ObservedObjects.PressedKeyEvent = PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)
            return nil
        }
        
        if ObservedObjects.EventDict.keys.contains(PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)) && ObservedToggles.KeyMap == true {
            let value:EventStruct = ObservedObjects.EventDict[PressedKeyEventStringMaker(keycode: MouseBtnNum(val: event.buttonNumber), Flag: event.modifierFlags.rawValue + 256)]!
            let ReturnValue = CreateNSEvent(event: event, KeyCode:value.keys, Flag: value.FlagNum)
            return ReturnValue.cgEvent
        }
       else { return cgEvent }
    }
    if(event.type == .keyUp || event.type == .keyDown){
            
        let checkEventDict = ObservedObjects.EventDict[PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)]
        let CMDFLAG = [1048840, 1048848, 1048856]
        
         
         if ObservedObjects.PressedKey == "Waiting"{
             
                 let FlagString = GetFlags(Val: event.modifierFlags.rawValue)
                 KeyMaps[event.keyCode] != nil ? (ObservedObjects.PressedKey = FlagString + KeyMaps[event.keyCode]!) : (ObservedObjects.PressedKey = FlagString + String(event.keyCode))
                 ObservedObjects.PressedKeyEvent = PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)
             
             return nil
         }
         if ObservedObjects.ReturnKey == "Waiting"{
             
                let FlagString = GetFlags(Val: event.modifierFlags.rawValue)
                KeyMaps[event.keyCode] != nil ? (ObservedObjects.ReturnKey = KeyMaps[event.keyCode]! + FlagString) : (ObservedObjects.ReturnKey = FlagString + String(event.keyCode))
                ObservedObjects.ReturnKeyEvent = EventStruct(keys: event.keyCode, FlagNum: event.modifierFlags.rawValue)
             
             return nil
         }
        
        
        
        if ((event.type == .keyDown && ObservedToggles.CMDQ == true) && ((event.keyCode == 12 && CMDFLAG.contains(Int(event.modifierFlags.rawValue))) && (ObservedToggles.KeyMap == false || (ObservedToggles.KeyMap == true && checkEventDict == nil)) ||
                (ObservedToggles.KeyMap == true && checkEventDict != nil && checkEventDict!.keys == 12 && CMDFLAG.contains(Int(checkEventDict!.FlagNum))))
        ){
            
                 return IsAlertOn(cgEvent: cgEvent)
         }
        
        else if ObservedObjects.EventDict.keys.contains(PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)) && ObservedToggles.KeyMap == true {
             let value:EventStruct = ObservedObjects.EventDict[PressedKeyEventStringMaker(keycode: event.keyCode, Flag: event.modifierFlags.rawValue)]!
             let ReturnValue = CreateNSEvent(event: event, KeyCode:value.keys, Flag: value.FlagNum)
             return ReturnValue.cgEvent
         }
        
        else { return cgEvent }
        
    }else  if event.type == .scrollWheel && ObservedToggles.MouseWheel == true{
        AlertIsOn = false
                if (event.momentumPhase.rawValue == 0 && event.phase.rawValue == 0) {
                    return CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.pixel, wheelCount: 1, wheel1: Int32(event.deltaY * -10), wheel2: 0, wheel3: 0)
                }
                else{
                    return cgEvent
                }
            }
    
 else {
    event.type != .keyUp ? AlertIsOn = false : nil
    return cgEvent
  }
}

