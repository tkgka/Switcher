//
//  PreventKeyModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import Foundation

class PreventKeyModel: ObservableObject {
    
    @Published var preventedKeys: PreventedKeys = [.init(flags: [.leftCommand], key: .q), .init(flags: [.rightCommand], key: .q), .init(flags: [.bothCommands], key: .q)]
    @Published var isAddingNewValue: Bool = false
    @Published var newValue: PreventedKey?
    
    
    // MARK: - Singleton
    
    static let shared = PreventKeyModel()
}
