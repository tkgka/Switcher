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
        let win = self.setWindow()
        win.title = title
        win.makeKeyAndOrderFront(sender)
        win.orderFrontRegardless()
        return win
    }
}
