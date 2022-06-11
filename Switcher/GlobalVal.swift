//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import Foundation
import AppKit

var KeyMapWindow:NSWindow? = nil

var AlertIsOn:Bool = false

var AlertSize:CGFloat = 200.0

let DefaultTimeout = 1.5


class ObservableToggles: ObservableObject {
    @Published var CMDQ:Bool = UserDefaults.standard.bool(forKey: "CMDQ")
    @Published var MouseWheel:Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
    @Published var KeyMap:Bool = UserDefaults.standard.bool(forKey: "KeyMap")
}


class ObservableKeyVal: ObservableObject {
    @Published var PressedKeyList:[UInt] = []
    @Published var ReturnKeyList:[UInt] = []
    @Published var PressedKey: String = "PressedKey"
    @Published var ReturnKey: String = "Returnkey"
    @Published var PressedKeyEvent: String?
    @Published var ReturnKeyEvent: EventStruct?
    var EventDict : [String : EventStruct] = [:]
}

class ObservableAlertKeyVal: ObservableObject {
    @Published var PressedKey: String = "AlertKey"
    @Published var PressedKeyEvent:[String] = []
}

struct EventStruct:Codable {
    let keys: UInt16!
    let FlagNum: UInt!
}

var ObservedKeyVals = ObservableKeyVal()
var ObservedAlertVals = ObservableAlertKeyVal()
var ObservedToggles = ObservableToggles()

