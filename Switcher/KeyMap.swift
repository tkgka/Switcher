//
//  KeyMap.swift
//  Switcher
//
//  Created by 김수환 on 2022/05/09.
//

import Foundation

enum KeyMap: UInt16, Codable {
    case a = 0x00
    case b = 0x0B
    case c = 0x08
    case d = 0x02
    case e = 0x0E
    case f = 0x03
    case g = 0x05
    case h = 0x04
    case i = 0x22
    case j = 0x26
    case k = 0x28
    case l = 0x25
    case m = 0x2E
    case n = 0x2D
    case o = 0x1F
    case p = 0x23
    case q = 0x0C
    case r = 0x0F
    case s = 0x01
    case t = 0x11
    case u = 0x20
    case v = 0x09
    case w = 0x0D
    case x = 0x07
    case y = 0x10
    case z = 0x06
    case backtick = 0x32
    case one = 0x12
    case two = 0x13
    case three = 0x14
    case four = 0x15
    case five = 0x17
    case six = 0x16
    case seven = 0x1A
    case eight = 0x1C
    case nine = 0x19
    case zero = 0x1D
    case minus = 0x1B
    case equal = 0x18
    case delete = 0x33
    case escape = 0x35
    case f1 = 0x7A
    case f2 = 0x78
    case f3 = 0x63
    case f4 = 0x76
    case f5 = 0x60
    case f6 = 0x61
    case f7 = 0x62
    case f8 = 0x64
    case f9 = 0x65
    case f10 = 0x6D
    case f11 = 0x67
    case f12 = 0x6F
    case f13 = 0x69
    case f14 = 0x6B
    case f15 = 0x71
    case left = 0x7B
    case right = 0x7C
    case up = 0x7E
    case down = 0x7D
    case enter = 0x24
    case tab = 0x30
    case space = 0x31
    case home = 0x73
    case end = 0x77
    case pageUp = 0x74
    case pageDown = 0x79
    case deleteForward = 0x75
    case comma = 0x2B
    case period = 0x2F
    case slash = 0x2C
    case semicolon = 0x29
    case quote = 0x27
    case leftBracket = 0x21
    case rightBracket = 0x1E
    case backSlash = 0x2A
    case shift = 0x38
    case control = 0x3B
    case option = 0x3A
    case command = 0x36
    case function = 0x3F
    case mouseButton3 = 0x3eb // buttonNumber + 1000
    case mouseButton4 = 0x3ec
    case mouseButton5 = 0x3ed
}


// MARK: - String Value

extension KeyMap {
    
    var string: String {
        switch self {
        case .a:
            return "a"
        case .b:
            return "b"
        case .c:
            return "c"
        case .d:
            return "d"
        case .e:
            return "e"
        case .f:
            return "f"
        case .g:
            return "g"
        case .h:
            return "h"
        case .i:
            return "i"
        case .j:
            return "j"
        case .k:
            return "k"
        case .l:
            return "l"
        case .m:
            return "m"
        case .n:
            return "n"
        case .o:
            return "o"
        case .p:
            return "p"
        case .q:
            return "q"
        case .r:
            return "r"
        case .s:
            return "s"
        case .t:
            return "t"
        case .u:
            return "u"
        case .v:
            return "v"
        case .w:
            return "w"
        case .x:
            return "x"
        case .y:
            return "y"
        case .z:
            return "z"
        case .backtick:
            return "`"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        case .zero:
            return "0"
        case .minus:
            return "-"
        case .equal:
            return "="
        case .delete:
            return "􀆛"
        case .escape:
            return "esc"
        case .f1:
            return "f1"
        case .f2:
            return "f2"
        case .f3:
            return "f3"
        case .f4:
            return "f4"
        case .f5:
            return "f5"
        case .f6:
            return "f6"
        case .f7:
            return "f7"
        case .f8:
            return "f8"
        case .f9:
            return "f9"
        case .f10:
            return "f10"
        case .f11:
            return "f11"
        case .f12:
            return "f12"
        case .f13:
            return "f13"
        case .f14:
            return "f14"
        case .f15:
            return "f15"
        case .left:
            return "􀄦"
        case .right:
            return "􀄧"
        case .up:
            return "􀄤"
        case .down:
            return "􀄥"
        case .enter:
            return "􀅇"
        case .tab:
            return "􁂎"
        case .space:
            return "space"
        case .home:
            return "􀄿"
        case .end:
            return "􀅀"
        case .pageUp:
            return "􀄨"
        case .pageDown:
            return "􀄩"
        case .deleteForward:
            return "􁂒"
        case .comma:
            return ","
        case .period:
            return "."
        case .slash:
            return "/"
        case .semicolon:
            return ";"
        case .quote:
            return "'"
        case .leftBracket:
            return "["
        case .rightBracket:
            return "]"
        case .backSlash:
            return "\\"
        case .shift:
            return "􀆝"
        case .control:
            return "􀆍"
        case .option:
            return "􀆕"
        case .command:
            return "􀆔"
        case .function:
            return "Fn"
        case .mouseButton3:
            return "MBtn3"
        case .mouseButton4:
            return "MBtn4"
        case .mouseButton5:
            return "MBtn5"
        }
    }
}
