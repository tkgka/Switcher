//
//  MakeMenuButton.swift
//  Switcher
//
//  Created by 김수환 on 2023/06/10.
//

import SwiftUI

extension AppDelegate {
    
    func MakeMenuButton() {
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: MenuView())
        popOver.contentSize = NSSize(width: 360, height: 800)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let MenuButton = statusItem?.button{
            MenuButton.image = NSImage(named: "icon")
            MenuButton.image?.isTemplate = true  // change image color to surrounding environment
            MenuButton.action = #selector(MenuButtonToggle)
        }
    }
}
