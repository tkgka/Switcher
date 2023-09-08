//
//  PreventKeyModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/06.
//

import Foundation
import AppKit

class PreventKeyModel: ObservableObject {
    
    @Published var preventedKeys: PreventedKeys = PreventKeyModel.load() {
        didSet {
            PreventKeyModel.save(preventedKeys: preventedKeys)
        }
    }
    @Published var isAddingNewValue: Bool = false
    @Published var newValue: PreventedKey?
    
    
    // MARK: - Singleton
    
    static let shared = PreventKeyModel()
    
    
    // MARK: - Save
    
    fileprivate static func save(preventedKeys: PreventedKeys) {
        guard
            let fileURL = Path.fileURL,
            let data = try? JSONEncoder().encode(preventedKeys)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    
    // MARK: - Load
    
    fileprivate static func load() -> PreventedKeys {
        guard let fileURL = Path.fileURL,
              let data = try? Data(contentsOf: fileURL),
              let preventedKeys = try? JSONDecoder().decode(PreventedKeys.self, from: data) else {
            return [.init(flags: [.leftCommand], key: .q), .init(flags: [.rightCommand], key: .q), .init(flags: [.bothCommands], key: .q)]
        }
        return preventedKeys
    }
}


// MARK: - Constant

private extension PreventKeyModel {
    
    enum Path {
        static var preventKeyModelURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let preventKeyModelURL = documentsDirectoryURL.appendingPathComponent("PreventKeyModel")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: preventKeyModelURL.absoluteString) {
                try? fileManager.createDirectory(
                    at: preventKeyModelURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            return preventKeyModelURL
        }
        
        static var fileURL: URL? {
            return preventKeyModelURL?.appendingPathComponent("Prevented-key-list.json")
        }
    }
}
