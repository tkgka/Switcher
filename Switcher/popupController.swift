//
//  popupController.swift
//  Switcher
//
//  Created by 김수환 on 2022/01/21.
//

import SwiftUI

extension View {
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
    func displayAsAlert(win:NSWindow){
        AlertIsOn = true
        win.isMovableByWindowBackground = false
        win.titleVisibility = .hidden
        win.titlebarAppearsTransparent = true
        win.isOpaque = false
        win.styleMask.remove(.closable)
        win.styleMask.remove(.fullScreen)
        win.styleMask.remove(.miniaturizable)
        win.styleMask.remove(.fullSizeContentView)
        win.styleMask.remove(.resizable)
        win.backgroundColor = NSColor.clear
        win.alphaValue = 0.98 //you can remove this line but it adds a nice effect to it
        win.orderFrontRegardless()
        DispatchQueue.main.asyncAfter(deadline: .now()+DefaultTimeout) {
            AlertIsOn = false
            closeWindow(window: win)
        }
    }
}

func setWindow() -> NSWindow{
    let controller = NSHostingController(rootView: ContentView())
    let win = NSWindow(contentViewController: controller)
    return win
}

func closeWindow(window:NSWindow){
    window.close()
}
