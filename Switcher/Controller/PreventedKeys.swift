//
//  PreventedKeys.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/05.
//

import Foundation

typealias PreventedKeys = [PreventedKey]

struct PreventedKey {
    let flags: [FlagMap]
    let key: KeyMap
}


// MARK: - Sort

extension [FlagMap] {
    
    var sorted: [FlagMap] {
        self.sorted(by: {$0.rawValue > $1.rawValue})
    }
    
    var sortedString: String {
        String(self.sorted.flatMap { flag in
            flag.string
        })
    }
}
