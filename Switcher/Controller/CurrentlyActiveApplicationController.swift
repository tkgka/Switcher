//
//  CurrentlyActiveApplicationController.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/07.
//

import Foundation
import AppKit

struct CurrentlyActiveApplicationController {
    
    func isKeyPreventApplicationsContainFfrontmostApplication(applications:[String]) -> Bool {
        guard applications.count > 1 else {
            return true
        }
        
        guard let app = Constant.workspace.frontmostApplication,
              applications.contains(app.bundleIdentifier ?? "")
        else {
            return false
        }
        return true
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
