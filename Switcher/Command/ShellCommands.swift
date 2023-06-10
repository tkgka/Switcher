//
//  ShellCommands.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/09.
//

import Foundation

// open settings -> security & privacy
let Privacy_Accessibility = "open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'"

func shellCommand(arg: String) -> Void {
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.arguments = ["-c", arg]
    task.standardOutput = Pipe()
    task.launch()
}
