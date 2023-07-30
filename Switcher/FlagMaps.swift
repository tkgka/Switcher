//
//  FlagMaps.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import Foundation

enum FlagMaps: UInt {
    case `default` = 256
    case capsLock = 65792
    case leftShift = 131330
    case rightShift = 131332
    case bothShifts = 131334
    case leftControl = 262401
    case rightControl = 270592
    case bothControls = 270593
    case leftOption = 524576
    case rightOption = 524608
    case bothOptions = 524640
    case leftCommand = 1048840
    case rightCommand = 1048848
    case bothCommands = 1048856
    case function = 8388864
    case arrow = 10486016
}


extension FlagMaps {
    
    var string: String {
        switch self {
        case .`default`:
            return ""
        case .capsLock:
            return "capsLock"
        case .leftShift, .rightShift, .bothShifts:
            return "􀆝"
        case .leftControl, .rightControl, .bothControls:
            return "􀆍"
        case .leftOption, .rightOption, .bothOptions:
            return "􀆕"
        case .leftCommand, .rightCommand, .bothCommands:
            return "􀆔"
        case .function:
            return "Fn"
        case .arrow:
            return ""
        }
    }
}
