import Cocoa

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

    func replay(into proxy: CGEventTapProxy, from event: CGEvent, isRight: Bool) {
//      print("replay")
      task.cancel()
      let source = CGEventSource(event: event)
      let mouseDownEvent = mouseDownEvent.copy()!
      if isRight {
        mouseDownEvent.type = .rightMouseDown
        mouseDownEvent.setIntegerValueField(.mouseEventButtonNumber, value: Int64(CGMouseButton.right.rawValue))
      }
      mouseDownEvent.tapPostEvent(proxy)
      mouseMoves.forEach {
        CGEvent(
          mouseEventSource: source,
          mouseType: isRight ? .rightMouseDragged : .leftMouseDragged,
          mouseCursorPosition: $0,
          mouseButton: isRight ? .right : .left
        )?.tapPostEvent(proxy)
      }
    }
  }
}

var value = false
func handle(event: NSEvent, cgEvent: CGEvent, wrapper: Wrapper, proxy: CGEventTapProxy) -> CGEvent? {
    if event.type == .keyDown && CMDQ == true{
//        print(event.modifierFlags)
        if event.keyCode == 12 && ( // P key down
            event.modifierFlags.rawValue == 1048840 || // right command key down
            event.modifierFlags.rawValue == 1048848 || // left command key down
            event.modifierFlags.rawValue == 1048856){  // both command key down
            if value == true {
                value = false
                return cgEvent
            }else{
                value = true
                return nil
            }
            
        }else {
            value = false
            return cgEvent
        }
    } else  if event.type == .scrollWheel && MouseWheel == true{
                if (event.momentumPhase.rawValue == 0 && event.phase.rawValue == 0) {
//                    print(event.deltaY)
                    return CGEvent(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.pixel, wheelCount: 1, wheel1: Int32(event.deltaY * -10), wheel2: 0, wheel3: 0)
                }
                else{
                    return cgEvent
                }
            }
 else {
     
     value = false
    return cgEvent
  }
}




func dialogOKCancel(question: String, text: String) -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = NSAlert.Style.informational
    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
}


