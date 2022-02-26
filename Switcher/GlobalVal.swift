//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import Foundation

var CMDQ:Bool = UserDefaults.standard.bool(forKey: "CMDQ")
var MouseWheel:Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
var KeyMap:Bool = UserDefaults.standard.bool(forKey: "KeyMap")

var AlertIsOn:Bool = false
var AlertSize:CGFloat = 200.0

let DefaultTimeout = 1.5

var KeyDict : [UInt16 : [UInt16]] = [:]
var IsflagsChanged : [UInt16 : Bool] = [:]
let KeyMapsArr:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","`","1","2","3","4","5","6","7","8","9","0","-","=","ESC","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","􀄦","􀄧","􀄤","􀄥","􀆛","􁂒","􀅇","􁂎","Space","􀄿","􀅀","􀄨","􀄩",",",".","/",";","'","[","]","\\",]
let KeyMaps:[String: UInt16] = [
    "a":0x00,
    "b":0x0B,
    "c":0x08,
    "d":0x02,
    "e":0x0E,
    "f":0x03,
    "g":0x05,
    "h":0x04,
    "i":0x22,
    "j":0x26,
    "k":0x28,
    "l":0x25,
    "m":0x2E,
    "n":0x2D,
    "o":0x1F,
    "p":0x23,
    "q":0x0C,
    "r":0x0F,
    "s":0x01,
    "t":0x11,
    "u":0x20,
    "v":0x09,
    "w":0x0D,
    "x":0x07,
    "y":0x10,
    "z":0x06,
    "`":0x32,
    "1":0x12,
    "2":0x13,
    "3":0x14,
    "4":0x15,
    "5":0x17,
    "6":0x16,
    "7":0x1A,
    "8":0x1C,
    "9":0x19,
    "0":0x1D,
    "-":0x1B,
    "=":0x18,
    "􀆛":0x33,
    "ESC":0x35,
    "F1":0x7A,
    "F2":0x78,
    "F3":0x63,
    "F4":0x76,
    "F5":0x60,
    "F6":0x61,
    "F7":0x62,
    "F8":0x64,
    "F9":0x65,
    "F10":0x6D,
    "F11":0x67,
    "F12":0x6F,
    "F13":0x69,
    "F14":0x6B,
    "F15":0x71,
    "􀄦":0x7B,
    "􀄧":0x7C,
    "􀄥":0x7D,
    "􀄤":0x7E,
    "􀅇":0x24,
    "􁂎":0x30,
    "Space":0x31,
    "􀄿":0x73,
    "􀅀":0x77,
    "􀄨":0x74,
    "􀄩":0x79,
    "􁂒":0x75,
    ",":0x2B,
    ".":0x2F,
    "/":0x2C,
    ";":0x29,
    "'":0x27,
    "[":0x21,
    "]":0x1E,
    "\\":0x2A,
    "Any":0x00,
    "􀆝":0x38,
    "􀆍":0x3B,
    "􀆕":0x3A,
    "􀆔":0x36,
    "Fn":0x3F
]

let Flags = ["Any", "􀆝", "􀆍","􀆕","􀆔","Fn"]
let FlagMaps: [String: [UInt16]] =
[   "Fn":[0x3F,0x3F],
    "Any":[0x00,0x00],
    "􀆝":[0x38,0x3C],
    "􀆍":[0x3B,0x3E],
    "􀆕":[0x3A,0x3D],
    "􀆔":[0x36,0x37],]





extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}


extension Dictionary where Value: Equatable {
    func findKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
