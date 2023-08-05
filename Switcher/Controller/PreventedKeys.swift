//
//  PreventedKeys.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/05.
//

import Foundation

typealias PreventedKeys = [PreventedKey]

struct PreventedKey {
    let flag: FlagMap
    let key: KeyMap
}
