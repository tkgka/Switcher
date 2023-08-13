//
//  MappedKeys.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation
import AppKit

typealias MappedKeys = [MappedKey]

struct MappedKey {
    
    let newFlag: UInt
    let newKey: KeyMap
    let originalFlag: UInt
    let originalKey: KeyMap
}


extension NSEvent {
    
    var mappedKey: NSEvent? {
        guard let MappedKey = KeyMapModel.shared.mappedKeys.first(
            where: {
            $0.originalKey.rawValue == self.keyCode && $0.originalFlag == self.modifierFlags.rawValue
        }
        )
        else {
            return nil
        }
        
        return NSEvent.keyEvent(
            with: type,
            location: locationInWindow,
            modifierFlags: .init(rawValue: MappedKey.newFlag),
            timestamp: timestamp,
            windowNumber: windowNumber,
            context: nil,
            characters: "",
            charactersIgnoringModifiers: "",
            isARepeat: isARepeat,
            keyCode: MappedKey.newKey.rawValue
        )
    }
}

