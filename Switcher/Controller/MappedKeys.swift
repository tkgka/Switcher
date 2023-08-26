//
//  MappedKeys.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation
import AppKit

typealias MappedKeys = [MappedKey]

struct MappedKey: Hashable, Codable {
    
    let inputFlagAndKey: FlagAndKey
    let returnFlagAndKey: FlagAndKey
}

extension MappedKey {
    
    var inputFlagAndKeyString: String {
        "\(FlagMap.arrayFlags(flagNum: inputFlagAndKey.flag).sortedString) \(inputFlagAndKey.key.string)"
    }
    var returnFlagAndKeyString: String {
        "\(FlagMap.arrayFlags(flagNum: returnFlagAndKey.flag).sortedString) \(returnFlagAndKey.key.string)"
    }
}

struct FlagAndKey: Hashable, Codable {
    let flag: UInt
    let key: KeyMap
}


extension NSEvent {
    
    func mappedKey(keys: MappedKeys, isMouseKey: Bool) -> NSEvent? {
        guard let mappedKey = keys.first(
            where: {
                $0.inputFlagAndKey.key.rawValue == (isMouseKey ? self.uInt16ButtonNumber : self.keyCode) && $0.inputFlagAndKey.flag == self.modifierFlags.rawValue + (isMouseKey ? 256 : 0)
            }
        )
        else {
            return nil
        }
        
        var type: EventType {
            guard !(self.type == .otherMouseUp) else {
                return .keyUp
            }
            guard !(self.type == .otherMouseDown) else {
                return .keyDown
            }
            return self.type
        }
        return NSEvent.keyEvent(
            with: type,
            location: locationInWindow,
            modifierFlags: .init(rawValue: mappedKey.returnFlagAndKey.flag),
            timestamp: timestamp,
            windowNumber: windowNumber,
            context: nil,
            characters: "",
            charactersIgnoringModifiers: "",
            isARepeat: isMouseKey ? false : isARepeat,
            keyCode: mappedKey.returnFlagAndKey.key.rawValue
        )
    }
}
