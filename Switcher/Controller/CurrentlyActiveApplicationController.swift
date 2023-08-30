//
//  CurrentlyActiveApplicationController.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/07.
//

import Foundation
import AppKit

struct CurrentlyActiveApplicationController: CurrentlyActiveApplicationControllerType {
    
    func applicationsDataContainFfrontmostApplication(applications:[ApplicationData]) -> String? {
        let bundleIdentifiers = applications.compactMap { applicaiton in
            applicaiton.identifier
        }
        guard let app = Constant.workspace.frontmostApplication,
              bundleIdentifiers.contains(app.bundleIdentifier ?? "") else {
            return nil
        }
        return app.bundleIdentifier
    }
    
    
    func currentlyRunningApplications() -> [NSRunningApplication] {
        Constant.workspace.runningApplications
    }
}


// MARK: - Constant

private extension CurrentlyActiveApplicationController {
    
    enum Constant {
        static let workspace = NSWorkspace.shared
    }
}
