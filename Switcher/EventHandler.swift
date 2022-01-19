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
                ContentView().displayAlert()
                value = true
                delay()
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

func delay(){
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        value = false
    }
}
