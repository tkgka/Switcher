//
//  KeyMapModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation

class KeyMapModel: ObservableObject {
    
    @Published var keyMapedApplicationIdentifiers: [String] = ["com.apple.Safari"]
    @Published var mappedKeys: MappedKeys = [.init(inputFlagAndKey: .init(flag: 1048840, key: .a), returnFlagAndKey: .init(flag: 256, key: .q))]
    @Published var isAddingNewInputValue: Bool = false
    @Published var isAddingNewReturnValue: Bool = false
    @Published var newInputValue: FlagAndKey?
    @Published var newReturnValue: FlagAndKey?
    
    
    // MARK: - Singleton
    
    static let shared = KeyMapModel()
}
