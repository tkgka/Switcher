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

struct FlagAndKey: Hashable, Codable {
    let flag: UInt
    let key: KeyMap
}


extension NSEvent {
    
    func mappedKey(keys: MappedKeys) -> NSEvent? {
        guard let MappedKey = keys.first(
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

