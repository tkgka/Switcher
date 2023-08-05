//
//  FlagMap.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import Foundation

enum FlagMap: UInt {
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


// MARK: - Array Flags

extension FlagMap {
    
    static func arrayFlags(flagNum val: UInt) -> [FlagMap] {
        flagList = []
        flagToArrayFlagMaps(flagNum: val)
        return flagList
    }
    
    private static var flagList: [FlagMap] = []
    
    private static func flagToArrayFlagMaps(flagNum val: UInt) {
        if let flag = FlagMap(rawValue: val) {
            flagList.append(flag)
            return
        }
        guard val < FlagMap.arrow.rawValue * 2 else {
            return
        }
        guard val < FlagMap.arrow.rawValue else {
            flagList.append(.arrow)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.arrow.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.function.rawValue else {
            flagList.append(.function)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.function.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.leftCommand.rawValue else {
            flagList.append(.leftCommand)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.leftCommand.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.leftOption.rawValue else {
            flagList.append(.leftOption)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.leftOption.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.leftControl.rawValue else {
            flagList.append(.leftControl)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.leftControl.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.leftShift.rawValue else {
            flagList.append(.leftShift)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.leftShift.rawValue + FlagMap.default.rawValue)
        }
        guard val < FlagMap.capsLock.rawValue else {
            flagList.append(.capsLock)
            return flagToArrayFlagMaps(flagNum: val - FlagMap.capsLock.rawValue + FlagMap.default.rawValue)
        }
        adjustFlagLocation(flagNum: val - FlagMap.default.rawValue)
    }
    
    private static func adjustFlagLocation(flagNum val: UInt) {
        guard val < FlagMap.rightControl.rawValue - FlagMap.leftControl.rawValue else {
            flagList.removeAll(where: { $0 == .leftControl })
            flagList.append(.rightControl)
            return adjustFlagLocation(flagNum: val - (FlagMap.rightControl.rawValue - FlagMap.leftControl.rawValue))
        }
        guard val < FlagMap.rightOption.rawValue - FlagMap.leftOption.rawValue else {
            guard flagList.contains(.rightOption) else {
                flagList.removeAll(where: { $0 == .leftOption })
                flagList.append(.rightOption)
                return adjustFlagLocation(flagNum: val - (FlagMap.rightOption.rawValue - FlagMap.leftOption.rawValue))
            }
            flagList.removeAll(where: { $0 == .rightOption })
            flagList.append(.bothOptions)
            return adjustFlagLocation(flagNum: val - (FlagMap.rightOption.rawValue - FlagMap.leftOption.rawValue))
        }
        guard val < FlagMap.rightCommand.rawValue - FlagMap.leftCommand.rawValue else {
            guard flagList.contains(.rightCommand) else {
                flagList.removeAll(where: { $0 == .leftCommand })
                flagList.append(.rightCommand)
                return adjustFlagLocation(flagNum: val - (FlagMap.rightCommand.rawValue - FlagMap.leftCommand.rawValue))
            }
            flagList.removeAll(where: { $0 == .rightCommand })
            flagList.append(.bothCommands)
            return adjustFlagLocation(flagNum: val - (FlagMap.rightCommand.rawValue - FlagMap.leftCommand.rawValue))
        }
        guard val < FlagMap.rightShift.rawValue - FlagMap.leftShift.rawValue else {
            guard flagList.contains(.rightShift) else {
                flagList.removeAll(where: { $0 == .leftShift })
                flagList.append(.rightShift)
                return adjustFlagLocation(flagNum: val - (FlagMap.rightShift.rawValue - FlagMap.leftShift.rawValue))
            }
            flagList.removeAll(where: { $0 == .rightShift })
            flagList.append(.bothShifts)
            return adjustFlagLocation(flagNum: val - (FlagMap.rightShift.rawValue - FlagMap.leftShift.rawValue))
        }
        guard val == 1 else {
            return
        }
        flagList.removeAll(where: { $0 == .rightOption })
        flagList.append(.bothOptions)
    }
}

// MARK: - String

extension FlagMap {
    
    var string: String {
        switch self {
        case .`default`:
            return ""
        case .capsLock:
            return "capsLock"
        case .leftShift:
            return "L􀆝"
        case .rightShift:
            return "R􀆝"
        case .bothShifts:
            return "B􀆝"
        case .leftControl:
            return "L􀆍"
        case .rightControl:
            return "R􀆍"
        case .bothControls:
            return "B􀆍"
        case .leftOption:
            return "L􀆕"
        case .rightOption:
            return "R􀆕"
        case .bothOptions:
            return "B􀆕"
        case .leftCommand:
            return "L􀆔"
        case .rightCommand:
            return "R􀆔"
        case .bothCommands:
            return "B􀆔"
        case .function:
            return "Fn"
        case .arrow:
            return ""
        }
    }
}
