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
var FlagKey:[UInt16]! = [0x00]
func handle(event: NSEvent, cgEvent: CGEvent, wrapper: Wrapper, proxy: CGEventTapProxy) -> CGEvent? {
     if((event.type == .keyUp || event.type == .keyDown)){
         if ((event.type == .keyDown && CMDQ == true) && event.keyCode == 12 && ( // P key down
             event.modifierFlags.rawValue == 1048840 || // right command key down
             event.modifierFlags.rawValue == 1048848 || // left command key down
             event.modifierFlags.rawValue == 1048856) && (KeyDict.keys.contains(UInt16(event.keyCode)) == false || (KeyDict.keys.contains(UInt16(event.keyCode)) == true && KeyMap == false) )){ // both command key down
                 return IsAlertOn(cgEvent: cgEvent)
         
         }
         
         if ObservedObjects.PressedKey == "Waiting"{
             ObservedObjects.PressedKey = event.characters!+"("+String(event.keyCode)+")"
             ObservedObjects.PressedKeyEvent = cgEvent
             return nil
         }
         if ObservedObjects.ReturnKey == "Waiting"{
             ObservedObjects.ReturnKey = event.characters!+"("+String(event.keyCode)+")"
             ObservedObjects.ReturnKeyEvent = cgEvent
             return nil
         }
         else if (KeyDict.keys.contains(UInt16(event.keyCode)) && (FlagKey.contains(KeyDict[UInt16(event.keyCode)]![0]) || FlagKey.contains(KeyDict[UInt16(event.keyCode)]![1]) || KeyDict[UInt16(event.keyCode)]![0] == 0x00) && KeyMap == true){
            let Event = CreateEvent(event: event, cgEvent: cgEvent, dic: KeyDict, index: 2, keyDown: (event.type == .keyUp ? false : true)) // index 2 = mapped keys value, index 3 = mapped keys flag
             if (NSEvent(cgEvent: Event)?.keyCode == 12 && cgEvent.type == .keyDown && (Event.flags == .maskCommand || Event.flags.rawValue == 1048840 || Event.flags.rawValue == 1048848 || Event.flags.rawValue == 1048856)){
                return IsAlertOn(cgEvent: Event)
            }
        return Event
        }
        else { return cgEvent }
        
    }else if (event.type == .flagsChanged && KeyMap == true){
        FlagKey!.contains(UInt16(exactly: event.keyCode)!) == true ? FlagKey?.removeAll(where: { $0 == UInt16(event.keyCode) }) : (FlagKey?.append(UInt16(event.keyCode)))
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

