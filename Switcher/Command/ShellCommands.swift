//
//  ShellCommands.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/09.
//

import Foundation

struct ShellCommand {
    
    static func open(arg: Open) -> Void {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c", arg.rawValue]
        task.standardOutput = Pipe()
        task.launch()
    }
}

extension ShellCommand {
    
    enum Open: String {
        case OpenPrivacyAccessibility = "open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'"
    }
}
