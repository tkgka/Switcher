//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import Foundation
import AppKit

var keyMapWindow:NSWindow? = nil

var alertIsOn:Bool = false

class ObservableToggles: ObservableObject { // toggle switchs
    @Published var alertKey: Bool = UserDefaults.standard.bool(forKey: "AlertKey")
    @Published var mouseWheel: Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
    @Published var keyMap: Bool = UserDefaults.standard.bool(forKey: "KeyMap")
}

class ObservableKeyVal: ObservableObject { // Key to Map
    @Published var pressedKeyList:[UInt] = []
    @Published var returnKeyList:[UInt] = []
    @Published var pressedKey: String = "PressedKey"
    @Published var returnKey: String = "Returnkey"
    @Published var pressedKeyEvent: String?
    @Published var returnKeyEvent: EventStruct?
    var EventDict : [String : EventStruct] = [:]
}

class ObservableAlertKeyVal: ObservableObject { // Key to show Alert when pressed
    @Published var pressedKey: String = "AlertKey"
    @Published var pressedKeyEvent:[String] = [] // List of Alerts keys
    @Published var alertList:[String:NSImage] = [:] //applications
}

struct EventStruct:Codable { // key Event 담당 struct
    let keys: UInt16!
    let flagNum: UInt!
}

var observedKeyVal = ObservableKeyVal()
var observedAlertVal = ObservableAlertKeyVal()
var observedToggles = ObservableToggles()
