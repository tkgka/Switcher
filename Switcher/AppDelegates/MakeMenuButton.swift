//
//  MakeMenuButton.swift
//  Switcher
//
//  Created by 김수환 on 2023/06/10.
//

import SwiftUI

extension AppDelegate {
    
    func makeMenuButton() {
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: MenuView())
        popOver.contentSize = NSSize(width: 360, height: 800)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let menuButton = statusItem?.button{
            menuButton.image = NSImage(named: "icon")
            menuButton.image?.isTemplate = true  // change image color to surrounding environment
            menuButton.action = #selector(MenuButtonToggle)
        }
    }
}
