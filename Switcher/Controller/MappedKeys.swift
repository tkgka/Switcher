//
//  MappedKeys.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation
import AppKit

typealias MappedKeys = [MappedKey]

struct MappedKey: Hashable {
    
    let inputFlagAndKey: FlagAndKey
    let returnFlagAndKey: FlagAndKey
}

struct FlagAndKey: Hashable {
    let flag: UInt
    let key: KeyMap
}


extension NSEvent {
    
    var mappedKey: NSEvent? {
        guard let MappedKey = KeyMapModel.shared.mappedKeys.first(
            where: {
                $0.inputFlagAndKey.key.rawValue == self.keyCode && $0.inputFlagAndKey.flag == self.modifierFlags.rawValue
        }
        )
        else {
            return nil
        }
        
        return NSEvent.keyEvent(
            with: type,
            location: locationInWindow,
            modifierFlags: .init(rawValue: MappedKey.returnFlagAndKey.flag),
            timestamp: timestamp,
            windowNumber: windowNumber,
            context: nil,
            characters: "",
            charactersIgnoringModifiers: "",
            isARepeat: isARepeat,
            keyCode: MappedKey.returnFlagAndKey.key.rawValue
        )
    }
}

