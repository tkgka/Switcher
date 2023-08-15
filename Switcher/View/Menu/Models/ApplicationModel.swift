//
//  ApplicationModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/15.
//

import AppKit

class ApplicationModel: ObservableObject {
    @Published var applications: [ApplicationData] = []
    
    
    // MARK: - Singleton
    
    static let shared = ApplicationModel()
}


struct ApplicationData: Hashable {
    let identifier: String
    let image: NSImage?
    var preventedKeys: PreventedKeys
    var mappedKeys: MappedKeys
}
