import Cocoa
import SwiftUI
import AlertPopup
var currentWindow:NSWindow?

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
     if((event.type == .keyUp || event.type == .keyDown)){
         if ((event.type == .keyDown && CMDQ == true) && event.keyCode == 12 && ( // P key down
             event.modifierFlags.rawValue == 1048840 || // right command key down
             event.modifierFlags.rawValue == 1048848 || // left command key down
             event.modifierFlags.rawValue == 1048856) && (KeyDict.keys.contains(UInt16(event.keyCode)) == false || (KeyDict.keys.contains(UInt16(event.keyCode)) == true && KeyMap == false) )){ // both command key down
                 return IsAlertOn(cgEvent: cgEvent)
         
         }
         
         if ObservedObjects.PressedKey == "Waiting"{
             let FuncNumToText = FuncNumToText()
             FuncNumToText.FlagNumToString(Val: Int(event.modifierFlags.rawValue))
             print(FuncNumToText.ReturnVal)
             
             KeyMaps[event.keyCode] != nil ? (ObservedObjects.PressedKey = FuncNumToText.ReturnVal.rawValue + KeyMaps[event.keyCode]!) : (ObservedObjects.PressedKey = FuncNumToText.ReturnVal.rawValue + String(event.keyCode))
             ObservedObjects.PressedKeyEvent = PressedKeyEventStringMaker(event: event)
             return nil
         }
         if ObservedObjects.ReturnKey == "Waiting"{
             let FuncNumToText = FuncNumToText()
             FuncNumToText.FlagNumToString(Val: Int(event.modifierFlags.rawValue))
             print(FuncNumToText.ReturnVal)
             KeyMaps[event.keyCode] != nil ? (ObservedObjects.ReturnKey = KeyMaps[event.keyCode]! + FuncNumToText.ReturnVal.rawValue) : (ObservedObjects.ReturnKey = String(event.keyCode) + FuncNumToText.ReturnVal.rawValue)
             ObservedObjects.ReturnKeyEvent = EventStruct(keys: event.keyCode, FlagNum: event.modifierFlags.rawValue)
             return nil
         }
         
         if ObservedObjects.EventDict.keys.contains(PressedKeyEventStringMaker(event: event)) && KeyMap == true {
             let value:EventStruct = ObservedObjects.EventDict[PressedKeyEventStringMaker(event: event)]!
             let ReturnValue = CreateNSEvent(event: event, KeyCode:value.keys, Flag: value.FlagNum)
             return ReturnValue.cgEvent
//             return CreateCGEvent(event: EventDict[PressedKeyEventStringMaker(event: event)]!, timestamp: cgEvent.timestamp, KeyDown: keyDown[event.type]!)
         }
        else {
            return cgEvent }
        
     }else if (event.type == .flagsChanged && KeyMap == true){
        return cgEvent
        
    }else  if event.type == .scrollWheel && MouseWheel == true{
                if (event.momentumPhase.rawValue == 0 && event.phase.rawValue == 0) {
                    return CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.pixel, wheelCount: 1, wheel1: Int32(event.deltaY * -10), wheel2: 0, wheel3: 0)
                }
                else{
                    return cgEvent
                }
            }
    
 else {
    event.type == .keyDown ? AlertIsOn = false : nil
    return cgEvent
  }
}

