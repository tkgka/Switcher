//
//  MenuModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/29.
//

import Foundation

class MenuModel: ObservableObject {
    
    @Published var preventKeyPressByMistake: Bool = UserDefaults.standard.bool(forKey: "PreventKeyPressByMistake")
    @Published var mouseWheel: Bool = UserDefaults.standard.bool(forKey: "MouseWheel")
    @Published var keyMap: Bool = UserDefaults.standard.bool(forKey: "KeyMap")
    
    // MARK: - Singleton
    
    static let shared = MenuModel()
}
