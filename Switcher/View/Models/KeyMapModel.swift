//
//  KeyMapModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/13.
//

import Foundation

class KeyMapModel: ObservableObject {
    
    @Published var mappedKeys: MappedKeys = KeyMapModel.load() {
        didSet {
            KeyMapModel.save(mappedKeys: mappedKeys)
        }
    }
    @Published var isAddingNewInputValue: Bool = false
    @Published var isAddingNewReturnValue: Bool = false
    @Published var newInputValue: FlagAndKey?
    @Published var newReturnValue: FlagAndKey?
    
    
    // MARK: - Singleton
    
    static let shared = KeyMapModel()
    
    
    // MARK: - Save
    
    fileprivate static func save(mappedKeys: MappedKeys) {
        guard
            let fileURL = Path.fileURL,
            let data = try? JSONEncoder().encode(mappedKeys)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    
    // MARK: - Load
    
    fileprivate static func load() -> MappedKeys {
        guard let fileURL = Path.fileURL,
              let data = try? Data(contentsOf: fileURL),
              let mappedKeys = try? JSONDecoder().decode(MappedKeys.self, from: data) else {
            return MappedKeys()
        }
        return mappedKeys
    }
}


// MARK: - Constant

private extension KeyMapModel {
    
    enum Path {
        static var keyMapModelURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let keyMapModelURL = documentsDirectoryURL.appendingPathComponent("KeyMapModel")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: keyMapModelURL.absoluteString) {
                try? fileManager.createDirectory(
                    at: keyMapModelURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            return keyMapModelURL
        }
        
        static var fileURL: URL? {
            return keyMapModelURL?.appendingPathComponent("mapped-key-list.json")
        }
    }
}
