//
//  AppDelegate.swift
//  Switcher
//
//  Created by 김수환 on 2023/06/10.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var state = Wrapper()
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    public func applicationDidFinishLaunching(_ notification: Notification) {
        if !AXIsProcessTrusted() {
            ShellCommand.open(arg: .OpenPrivacyAccessibility)
            let _ = WelcomeView().openInWindow(title: "Switcher", sender: self)
        }
        createEventTap()
        makeMenuButton()
    }
    
    @objc func MenuButtonToggle(sender: AnyObject) {
        //      showing popover
        if popOver.isShown{
            popOver.performClose(sender)
        }else{
            //Top Get Button Location for popover arrow
            self.popOver.show(relativeTo: (statusItem?.button!.bounds)!, of: (statusItem?.button!)!, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}


// MARK: - Open In Window

extension View {
    
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let win = NSWindow(contentViewController: NSHostingController(rootView: self))
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
}
