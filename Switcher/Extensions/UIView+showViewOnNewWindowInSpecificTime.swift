//
//  UIView+ShowViewOnNewWindowInSpecificTime.swift
//  Switcher
//
//  Created by 김수환 on 2023/07/30.
//

import SwiftUI

extension View {
    
    // MARK: - Interface
    
    func showViewOnNewWindowInSpecificTime(during timer: CGFloat) -> NSWindow {
        let alertWindow = self.setWindow()
        displayAsAlert(win: alertWindow, Timer: timer)
        return alertWindow
    }
    
    
    // MARK: - Attribute
    
    private func displayAsAlert(win:NSWindow, Timer:Double) {
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
        win.orderFrontRegardless()
        DispatchQueue.main.asyncAfter(deadline: .now() + Timer) {
            win.close()
        }
    }
    
    private func setWindow() -> NSWindow {
        NSWindow(contentViewController: NSHostingController(rootView: self))
    }
}
