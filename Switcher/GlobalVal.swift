//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import Foundation
import AppKit

var CMDQ:Bool = UserDefaults.standard.bool(forKey: "CMDQ")
var MouseWheel:Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
var KeyMap:Bool = UserDefaults.standard.bool(forKey: "KeyMap")
var ListOfKeyMap:[[String]] = [[String]](rawValue: UserDefaults.standard.string(forKey: "ListOfKeyMap")!) ?? [["a","Any","a","Any"]]
var IsChecked:[Bool] = [Bool](rawValue: UserDefaults.standard.string(forKey: "IsChecked")!) ?? [false]

var AlertIsOn:Bool = false
var AlertSize:CGFloat = 200.0

let DefaultTimeout = 1.5

var KeyDict : [UInt16 : [UInt16]] = [:]
var IsflagsChanged : [UInt16 : Bool] = [:]
let KeyMapsArr:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","`","1","2","3","4","5","6","7","8","9","0","-","=","ESC","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","􀄦","􀄧","􀄤","􀄥","􀆛","􁂒","􀅇","􁂎","Space","􀄿","􀅀","􀄨","􀄩",",",".","/",";","'","[","]","\\",]
let KeyMaps:[UInt16:String] = [
    0x00:"a",
    0x0B:"b",
    0x08:"c",
    0x02:"d",
    0x0E:"e",
    0x03:"f",
    0x05:"g",
    0x04:"h",
    0x22:"i",
    0x26:"j",
    0x28:"k",
    0x25:"l",
    0x2E:"m",
    0x2D:"n",
    0x1F:"o",
    0x23:"p",
    0x0C:"q",
    0x0F:"r",
    0x01:"s",
    0x11:"t",
    0x20:"u",
    0x09:"v",
    0x0D:"w",
    0x07:"x",
    0x10:"y",
    0x06:"z",
    0x32:"`",
    0x12:"1",
    0x13:"2",
    0x14:"3",
    0x15:"4",
    0x17:"5",
    0x16:"6",
    0x1A:"7",
    0x1C:"8",
    0x19:"9",
    0x1D:"0",
    0x1B:"-",
    0x18:"=",
    0x33:"􀆛",
    0x35:"ESC",
    0x7A:"F1",
    0x78:"F2",
    0x63:"F3",
    0x76:"F4",
    0x60:"F5",
    0x61:"F6",
    0x62:"F7",
    0x64:"F8",
    0x65:"F9",
    0x6D:"F10",
    0x67:"F11",
    0x6F:"F12",
    0x69:"F13",
    0x6B:"F14",
    0x71:"F15",
    0x7B:"􀄦",
    0x7C:"􀄧",
    0x7D:"􀄥",
    0x7E:"􀄤",
    0x24:"􀅇",
    0x30:"􁂎",
    0x31:"Space",
    0x73:"􀄿",
    0x77:"􀅀",
    0x74:"􀄨",
    0x79:"􀄩",
    0x75:"􁂒",
    0x2B:",",
    0x2F:".",
    0x2C:"/",
    0x29:";",
    0x27:"'",
    0x21:"[",
    0x1E:"]",
    0x2A:"\\",
    0x38:"􀆝",
    0x3B:"􀆍",
    0x3A:"􀆕",
    0x36:"􀆔",
    0x3F:"Fn",
]

let Flags = ["Any", "􀆝", "􀆍","􀆕","􀆔","Fn"]
let FlagMaps: [Int: String] =
[
    256:"Default",
    65792:"􁂎",
    131330:"􀆝",
    131332:"R􀆝",
    131334:"B􀆝",
    262401:"􀆍",
    270592:"R􀆍",
    270593:"B􀆍",
    524576:"􀆕",
    524608:"R􀆕",
    524640:"B􀆕",
    1048840:"􀆔",
    1048848:"R􀆔",
    1048856:"B􀆔",
    8388864:"FN",
]


















let keyDown:[NSEvent.EventType:Bool] = [.keyDown:true, .keyUp:false]



class ObservableList: ObservableObject {
    @Published var PressedKey: String = "PressedKey"
    @Published var ReturnKey: String = "Returnkey"
    @Published var PressedKeyEvent: String?
    @Published var ReturnKeyEvent: EventStruct?
    var EventDict : [String : EventStruct] = [:]
}

var ObservedObjects = ObservableList()



struct EventStruct:Codable {
    let keys: UInt16!
    let FlagNum: UInt!
}



