//
//  String+Localized.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
