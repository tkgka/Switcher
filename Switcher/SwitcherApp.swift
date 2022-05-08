//
//  Switcher
//
//  Created by 김수환 on 2022/01/08.
//

import SwiftUI
import Darwin // needed for exit(0)

@main
struct SwitcherApp: App {
    // Linking a created AppDelegate
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        // IMPORTANT
        Settings {
            ContentView()
            
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate{
    var state = Wrapper()
    var statusItem: NSStatusItem?
    var popOver = NSPopover()
    public func applicationDidFinishLaunching(_ notification: Notification) {
        if !AXIsProcessTrusted() {
            ShellCommand(arg: Privacy_Accessibility)
            WelcomeView().openInWindow(title: "Switcher", sender: self)
        }
            createEventTap()
            MakeMenuButton()
            SetKeyMapValue()
    }

    
    func MakeMenuButton(){
        popOver.behavior = .transient
        popOver.animates = true
        popOver.contentViewController = NSViewController()
        popOver.contentViewController?.view = NSHostingView(rootView: MenuView())
        popOver.contentSize = NSSize(width: 360, height: 800)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let MenuButton = statusItem?.button{
            
            MenuButton.image = NSImage(named: "Image")
            MenuButton.image?.isTemplate = true  // change image color to surrounding environment
            MenuButton.action = #selector(MenuButtonToggle)
        }
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
    

    func createEventTap() {
      let eventTap = CGEvent.tapCreate(
        tap: .cgSessionEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: [.keyDown, .keyUp, .flagsChanged, .leftMouseDown, .rightMouseDown, .scrollWheel, .otherMouseDown, .otherMouseUp],
        callback: { proxy, _, cgEvent, ctx in
          if let event = NSEvent(cgEvent: cgEvent),
             let wrapper = ctx?.load(as: Wrapper.self) {
            if let newEvent = handle(event: event, cgEvent: cgEvent, wrapper: wrapper, proxy: proxy) {
              /// Quoting from https://developer.apple.com/documentation/coregraphics/cgeventtapcallback?language=swift
              /// Your callback function should return one of the following:
              /// - The (possibly modified) event that is passed in. This event is passed back to the event system.
              ///   - [we call passUnretained here since the event system is retaining the original event]
              /// - A newly-constructed event. After the new event has been passed back to the event system, the new event will be released along with the original event.
              ///   - [we call passRetained here because the event system will eventually release the event we return]
              /// - `NULL` if the event passed in is to be deleted.
              if newEvent == cgEvent {
                return .passUnretained(cgEvent)
              } else {
                return .passRetained(newEvent)
              }
            } else {
              return nil
            }
          } else {
            print("Unexpected failure to construct state or NSEvent")
            return .passUnretained(cgEvent)
          }
        }, userInfo: &state)
      if let eventTap = eventTap {
        RunLoop.current.add(eventTap, forMode: .common)
        CGEvent.tapEnable(tap: eventTap, enable: true)
      }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        KeyMapWindow != nil ? (KeyMapWindow = nil) : nil
        return false
    }
    
  }

