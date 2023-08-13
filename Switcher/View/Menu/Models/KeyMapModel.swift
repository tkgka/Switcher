//
//  KeyMapModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation

class KeyMapModel: ObservableObject {
    
    @Published var keyMapedApplicationIdentifiers: [String] = ["com.apple.Safari"]
    @Published var mappedKeys: MappedKeys = [.init(newFlag: 256, newKey: .q, originalFlag: 1048840, originalKey: .a)]
    @Published var isAddingNewValue: Bool = false
    @Published var newValue: PreventedKey?
    
    
    // MARK: - Singleton
    
    static let shared = KeyMapModel()
}
