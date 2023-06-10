//
//  AppDelegate.swift
//  Switcher
//
//  Created by 김수환 on 2023/06/10.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var state = Wrapper()
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    public func applicationDidFinishLaunching(_ notification: Notification) {
        if !AXIsProcessTrusted() {
            shellCommand(arg: Privacy_Accessibility)
            let _ = WelcomeView().openInWindow(title: "Switcher", sender: self)
        }
        createEventTap()
        makeMenuButton()
        setKeyDefaultValue()
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
        keyMapWindow != nil ? (keyMapWindow = nil) : nil
        return false
    }
}
