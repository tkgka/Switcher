//
//  CurrentlyActiveApplicationControllerType.swift
//  Switcher
//
//  Created by 김수환 on 2023/08/30.
//

import Foundation
import AppKit

protocol CurrentlyActiveApplicationControllerType {
    
    func applicationsDataContainFfrontmostApplication(applications:[ApplicationData]) -> String?
    func currentlyRunningApplications() -> [NSRunningApplication]
}
