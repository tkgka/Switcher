//
//  createEventTap.swift
//  Switcher
//
//  Created by 김수환 on 2023/06/10.
//
// code from "https://github.com/j-f1/ForceClickToRightClick"

import AppKit

extension AppDelegate {
    
    func createEventTap() {
        let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: [.keyDown, .keyUp, .flagsChanged, .leftMouseDown, .rightMouseDown, .scrollWheel, .otherMouseDown, .otherMouseUp],
            callback: { proxy, _, cgEvent, ctx in
                if let event = NSEvent(cgEvent: cgEvent),
                   let wrapper = ctx?.load(as: Wrapper.self) {
                    if let newEvent = KeyInputController.handle(event: event, cgEvent: cgEvent, wrapper: wrapper, proxy: proxy) {
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
}
