//
//  ApplicationModel.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/15.
//

import AppKit

class ApplicationModel: ObservableObject {
    @Published var applications: [ApplicationData] = ApplicationModel.load() {
        didSet {
            ApplicationModel.save(applications: applications)
        }
    }
    
    // MARK: - Singleton
    
    static let shared = ApplicationModel()
    
    
    // MARK: - Save
    
    fileprivate static func save(applications: [ApplicationData]) {
        guard
            let fileURL = Path.fileURL,
            let data = try? JSONEncoder().encode(applications)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    
    // MARK: - Load
    
    fileprivate static func load() -> [ApplicationData] {
        guard let fileURL = Path.fileURL,
              let data = try? Data(contentsOf: fileURL),
              let applications = try? JSONDecoder().decode([ApplicationData].self, from: data) else {
            return []
        }
        return applications
    }
}

struct ApplicationData: Hashable, Codable {
    var uuid = UUID()
    let identifier: String
    var imageData: Data?
    var preventedKeys: PreventedKeys
    var mappedKeys: MappedKeys
}


private extension ApplicationModel {
    
    enum Path {
        static var preventKeyModelURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let preventKeyModelURL = documentsDirectoryURL.appendingPathComponent("ApplicationModel")
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
            return preventKeyModelURL?.appendingPathComponent("Application-data-list.json")
        }
    }
}
