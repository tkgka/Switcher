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
    if ((event.type == .keyDown && CMDQ == true) && event.keyCode == 12 && ( // P key down
        event.modifierFlags.rawValue == 1048840 || // right command key down
        event.modifierFlags.rawValue == 1048848 || // left command key down
        event.modifierFlags.rawValue == 1048856)){ // both command key down
            if AlertIsOn == true {
                AlertIsOn = false
                return cgEvent
            }else{
                if currentWindow != nil{
                    closeWindow(window: currentWindow!)
                    currentWindow = nil
                }
                currentWindow = ShowSystemAlert(ImageName: "exclamationmark.circle", AlertText: "Enter 􀆔q again \nto shutdown app", Timer: 1.5, ImageColor: Color("ImageColor"), FontColor: Color("FontColor"))
                AlertPopupTimeout()
                AlertIsOn = true
                return nil
            }
            
        
    } else if((event.type == .keyUp || event.type == .keyDown) && KeyMap == true){
        if KeyDict.keys.contains(UInt16(event.keyCode)) && (FlagKey.contains(KeyDict[UInt16(event.keyCode)]![0]) || FlagKey.contains(KeyDict[UInt16(event.keyCode)]![1]) || KeyDict[UInt16(event.keyCode)]![0] == 0x00){
        return CreateEvent(event: event, cgEvent: cgEvent, dic: KeyDict, index: 2, keyDown: (event.type == .keyUp ? false : true)) // index 2 = mapped keys value, index 3 = mapped keys flag
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
     AlertIsOn = false
    return cgEvent
  }
}

func AlertPopupTimeout(){
    DispatchQueue.main.asyncAfter(deadline: .now() + DefaultTimeout) {
        AlertIsOn = false
    }
}

func CreateEvent(event:NSEvent, cgEvent:CGEvent, dic:[UInt16 : [UInt16]], index:Int, keyDown:Bool) -> CGEvent{
    let Event = CGEvent(keyboardEventSource: nil, virtualKey: dic[UInt16(event.keyCode)]![index], keyDown: keyDown);
    Event?.timestamp = cgEvent.timestamp
        FlagMaps["Fn"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskSecondaryFn) : nil
        FlagMaps["Any"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = cgEvent.flags) : nil
        FlagMaps["􀆝"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskShift) : nil
        FlagMaps["􀆍"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskControl) : nil
        FlagMaps["􀆕"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskAlternate) : nil
        FlagMaps["􀆔"]!.contains(dic[UInt16(event.keyCode)]![index+1]) ? (Event?.flags = .maskCommand) : nil
    return Event!
}
